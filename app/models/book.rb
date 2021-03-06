class Book < ActiveRecord::Base
  # a Book may have comments (reviews)
  acts_as_commentable

  mount_uploader :uploaded_cover, UploadedCoverUploader

  has_and_belongs_to_many :categories

  has_many :contributions
  has_many :authors, through: :contributions
  belongs_to :publisher, :counter_cache => true
  has_many :awards, as: :awardable

  has_many  :writers, -> { where contributions: { job: 0 } },
            :through => :contributions,
            :class_name => "Author",
            :source => :author

  has_many  :contributors, -> { select("authors.*, contributions.job AS job").where.not(contributions: { job: 0 }) },
            :through => :contributions,
            :class_name => "Author",
            :source => :author

  has_many :bookshelves
  has_many :shelves, through: :bookshelves

  has_many :activities, as: :trackable, class_name: 'PublicActivity::Activity', dependent: :destroy
  belongs_to :series, :counter_cache => true, optional: true
  has_one :daily_suggestion
  belongs_to :main_writer, class_name: 'Author', optional: true
  has_many :ratings, as: :rateable
  belongs_to :genre, optional: true

  enum availability: %i(Κυκλοφορεί Υπό\ Έκδοση Εξαντλημένο Κυκλοφορεί\ -\ Εκκρεμής\ εγγραφή Έχει\ αποσυρθεί\ από\ την\ κυκλοφορία)
  enum cover_type: %i(Μαλακό\ εξώφυλλο Σκληρό\ εξώφυλλο Spiral)
  enum format: %i(Βιβλίο CD-ROM CD-Audio Κασέτα Χάρτης Επιτραπέζιο\ παιχνίδι Κασέτα\ VHS Παιχνίδια-Κατασκευές DVD-ROM Video\ DVD Video\ CD e-book Άλλο )

  LANGUAGES = %w(αγγλικά αλβανικά αραβικά αρμενικά αρχαία\ ελληνικά αφρικάανς αϊτινά\ κρεολικά βασκικά βιετναμικά βουλγαρικά γίντις γαλλικά γερμανικά γερμανοεβραϊκά γεωργιανά δανέζικα εβραϊκά ελληνικά ελληνικά\ της\ βίβλου ελληνικά\ του\ βυζαντίου εσπεράντο θιβετιανά ιαπωνικά ινδικά ιρλανδικά ισλανδικά ισπανικά ιταλικά καταλανικά κινεζικά κοπτικά κορεατικά κουρδικά κροατικά λατινικά λιθουανικά νορβηγικά ολλανδικά ουγγρικά ουκρανικά περσικά πολωνικά πομακικά πορτογαλικά ρουμανικά ρωσικά σερβικά σερβο-κροατικά σερβοβοσνιακά σλαβομακεδονικά σλοβακικά σλοβενικά σουηδικά τουρκικά τσεχικά φινλανδικά φλαμανδικά)

  scope :last_month, -> { where("created_at > ?", 1.month.ago) }

  before_destroy do
    categories.clear
    contributions.clear
    bookshelves.clear
    awards.clear
  end

  before_save :write_series_id
  before_save :write_main_writer_id

  # Log impressions filtered by ip
  is_impressionable :counter_cache => true, :unique => true

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  searchkick batch_size: 50,
             callbacks: :async,
             match: :word_start,
             searchable: [:tsearch_vector],
             word_start: [:tsearch_vector]

  def search_data
    {
      tsearch_vector: tsearch_vector.gsub("'", "").split(" "),
      publication_year: publication_year,
      author: main_author,
      publisher: publisher.try(:name),
      category: categories.try(:first).try(:name),
      series: series.try(:name),
      format: format,
      language: (original_language.present? ? original_language : "ελληνικά"),
      pages: pages_based_size,
      has_image: image.present?
      # title: title,
      # description: short_description
    }.merge(search_conversions)
  end

  def search_conversions
    {
      views: impressionist_count
    }
  end

  after_validation :calculate_search_terms, :if => :recalculate_search_terms?

  include PublicActivity::Common

  def language
    LANGUAGES[read_attribute(:language).to_i].to_s if read_attribute(:language)
  end

  def original_language
    LANGUAGES[read_attribute(:original_language).to_i].to_s if read_attribute(:original_language)
  end

  def main_author(reversed = false)
    if collective_work?
      I18n.t('books.collective_work')
    elsif writers.first.present?
      reversed ? writers.first.fullname_reversed : writers.first.fullname
    end
  end

  def short_description(max_chars = 350)
    return unless description.present?

    no_html_description = ActionView::Base.full_sanitizer.sanitize(description)
    if no_html_description.length <= max_chars
      no_html_description
    elsif no_html_description.length > max_chars
      "#{no_html_description[0...max_chars]}..."
    end
  end

  # Returns book cover url if there is one or the default not image.
  def cover
    if uploaded_cover_url.present?
      uploaded_cover_url
    else
      BookCoverUploadWorker.perform_async(id) if image.present?
      '/no_cover.jpg'
    end
  end

  def cover_og
    if uploaded_cover_url.present?
      og_cover = cover.gsub('.jpg', '_og.jpg')
      og_cover_path = Rails.public_path.to_s + og_cover
      if Pathname.new(og_cover_path).exist?
        og_cover
      else
        BookCoverOgGeneratorWorker.perform_async(id)
        cover
      end
    else
      cover
    end
  end

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :slugged_name,
      %i[slugged_name id]
    ]
  end

  def slugged_name(opts = {})
    opts[:max_expansions] ||= 1
    opts[:dashes] = true if opts[:dashes].nil?
    join_with = opts[:dashes] ? '-' : ' '

    converter = Greeklish.converter(max_expansions: opts[:max_expansions], generate_greek_variants: false)
    name_to_slug = ApplicationController.helpers.detone(UnicodeUtils.downcase(title).gsub('ς', 'σ').gsub(/[,.:'·-]/, ''))
    name_to_slug.split(' ').map do |word|
      converted = converter.convert(word)
      converted.present? ? converted : word
    end.flatten.uniq.join(join_with)
  end

  def calculate_search_terms
    terms = slugged_name(max_expansions: 3, dashes: false)
    terms += ' ' + original_title.downcase.gsub(/[,.:'·-]/,'') if original_title.present?
    terms += ' ' + ApplicationController.helpers.latinize(series_name) if series_name.present?
    terms += ' ' + isbn.gsub('-','') if isbn.present?
    terms += ' ' + isbn13.gsub('-','') if isbn13.present?
    update_attribute(:tsearch_vector, terms)
  end

  def recalculate_search_terms?
    :title_changed? || :original_title_changed? || :series_name_changed? || :isbn_changed? || :isbn13_changed?
  end

  def to_marc
    record = MARC::Record.new
    record.append(MARC::ControlField.new('001', id))
    record.append(MARC::ControlField.new('005', updated_at.strftime('%Y%m%d%H%M%S.%L')))
    record.append(MARC::DataField.new('020', '#',  '#', ['a', isbn.gsub('-','')])) if isbn
    record.append(MARC::DataField.new('020', '#',  '#', ['a', isbn13.gsub('-','')])) if isbn13
    record.append(MARC::DataField.new('022', '#',  '#', ['a', issn]))

    if original_language.present?
      record.append(MARC::DataField.new('041', '1',  '#', ['a', I18n.t('languages.greek')], ['h', original_language]))
    else
      record.append(MARC::DataField.new('041', '0',  '#', ['a', I18n.t('languages.greek')]))
    end

    record.append(MARC::DataField.new('082', '1',  '4', *(categories.map{|c| ['a', c.ddc]}), ['2', '23']))

    record.append(MARC::DataField.new('100', '1',  '#', ['a', main_author(true)], ['c', writers.try(:first).try(:associated_titles)], ['d', writers.try(:first).try(:associated_dates)]))
    record.append(MARC::DataField.new('245', '1',  '0', ['a', title], ['b', subtitle], ['c', screen_writers]))
    record.append(MARC::DataField.new('250', '#',  '#', ['a', screen_publication_version]))
    record.append(MARC::DataField.new('260', '#',  '#', ['a', publication_place], ['b', publisher.try(:name)], ['c', publication_year.try(:to_s)]))
    record.append(MARC::DataField.new('300', '#',  '#', ['a', screen_pages], ['b', screen_cover_type], ['c', screen_size]))

    record.append(MARC::DataField.new('490', '0',  '#', ['a', series_name], ['v', series_volume]))
    record.append(MARC::DataField.new('520', '#',  '#', ['a', subtitle]))

    categories.each do |category|
      record.append(MARC::DataField.new('650', '#',  '1', ['a', category.name]))
    end

    contributions.each do |contribution|
      record.append(MARC::DataField.new('700', '1',  '#', ['a', contribution.author.fullname_reversed], ['c', contribution.author.try(:associated_titles)], ['d', contribution.author.try(:associated_dates)], ['e', contribution.job])) unless contribution.author.fullname == main_author
    end
    record.append(MARC::DataField.new('765', '1',  '#', ['t', original_title]))

    record.append(MARC::DataField.new('903', '#',  '#', ['a', screen_price]))

    record
  end

  def screen_pages
    pages.to_s + I18n.t('books.pages') if pages
  end

  def screen_cover_type
    cover_type.try(:humanize)
  end

  def screen_size
    size + I18n.t('books.centimeters') if size
  end

  def screen_publication_version
    publication_version.to_s + I18n.t('books.n_version') if publication_version.present?
  end

  def screen_price
    '€' + price.to_s if price
  end

  def screen_writers
    writers.map(&:fullname).join(" [#{I18n.t('and')}] ")
  end

  def pages_based_size
    return unless pages.present?

    if pages < 100
      '< 100'
    elsif pages >= 100 && pages < 300
      '100 - 300'
    elsif pages >= 300 && pages < 600
      '300 - 600'
    elsif pages >= 600 && pages < 1000
      '600 - 1000'
    else
      '> 1000'
    end
  end

  def write_series_id
    return unless series_name.present?

    series_obj = Series.find_or_create_by(name: series_name)
    write_attribute(:series_id, series_obj.id)
  end

  def write_main_writer_id
    write_attribute(:main_writer_id, writers.first.id) if !collective_work && writers.first.present?
  end

  def self.get_popular
    Rails.cache.fetch("get_popular", expires_in: 2.days) do
      self.where(id: self.get_popular_ids)
    end
  end

  def self.get_popular_ids
    Rails.cache.fetch("get_popular_ids", expires_in: 2.days) do
      self.order(impressions_count: :desc).limit(8).ids
    end
  end

  def self.get_latest
    Rails.cache.fetch("get_latest", expires_in: 1.day) do
      self.where(id: self.get_latest_ids)
    end
  end

  def self.get_latest_ids
    Rails.cache.fetch("get_latest_ids", expires_in: 1.day) do
      self.order(created_at: :desc).where.not(image: '').limit(8).ids
    end
  end

  def self.get_awarded
    Rails.cache.fetch("get_awarded", expires_in: 3.days) do
      self.where(id: Award.most_awarded_book_ids)
    end
  end

  def self.get_random_awarded
    Rails.cache.fetch("get_random_awarded", expires_in: 1.day) do
      self.where(id: Award.random_awarded_book_ids)
    end
  end

  def update_main_writer_id
    update(main_writer_id: writers.first.id) if !collective_work && writers.first.present?
  end

  # def rewrite_series_name
  #   if (series_name =~ /· \d+ ·/).present?
  #     write_attribute(:series_name, series_name.gsub(/· \d+ ·/, '-'))
  #     save!
  #   end
  # end

  # def rewrite_series_volume
  #   if (series_name =~ /· \d+ ·/).present?
  #     volume = /\d+/.match(series_name)[0].to_i
  #     write_attribute(:series_volume, volume)
  #     save!
  #   end
  # end

end

# == Schema Information
#
# Table name: books
#
#  id                      :integer          not null, primary key
#  title                   :string
#  subtitle                :string
#  description             :text
#  image                   :string
#  isbn                    :string
#  isbn13                  :string
#  ismn                    :string
#  issn                    :string
#  series_name             :string
#  pages                   :integer
#  publication_year        :integer
#  publication_place       :string
#  price                   :decimal(6, 2)
#  price_updated_at        :date
#  size                    :string
#  cover_type              :integer          default("Μαλακό εξώφυλλο")
#  availability            :integer          default("Κυκλοφορεί")
#  format                  :integer          default("Βιβλίο")
#  original_language       :integer
#  original_title          :string
#  publisher_id            :integer
#  extra                   :string
#  biblionet_id            :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  collective_work         :boolean          default(FALSE)
#  series_volume           :integer
#  publication_version     :integer
#  impressions_count       :integer          default(0)
#  slug                    :string
#  language                :integer
#  tsearch_vector          :tsvector
#  series_id               :integer
#  liked_by_count_cache    :integer          default(0)
#  disliked_by_count_cache :integer          default(0)
#  bookshelves_count       :integer          default(0)
#  views_count             :integer          default(0)
#  uploaded_cover          :string
#  main_writer_id          :integer
#  first_publish_date      :date
#  current_publish_date    :date
#  future_publish_date     :date
#  genre_id                :bigint(8)
#
# Indexes
#
#  books_tsearch_idx              (tsearch_vector) USING gin
#  index_books_on_genre_id        (genre_id)
#  index_books_on_isbn            (isbn) UNIQUE
#  index_books_on_isbn13          (isbn13) UNIQUE
#  index_books_on_ismn            (ismn) UNIQUE
#  index_books_on_main_writer_id  (main_writer_id)
#  index_books_on_publisher_id    (publisher_id)
#  index_books_on_series_id       (series_id)
#  index_books_on_slug            (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (genre_id => genres.id)
#  fk_rails_...  (publisher_id => publishers.id)
#  fk_rails_...  (series_id => series.id)
#
