class Book < ActiveRecord::Base
   # a Book may have comments (reviews)
  acts_as_commentable

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
  belongs_to :series, :counter_cache => true

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


  # include PgSearch
  # pg_search_scope :search_by_title,
  #   :against => [
  #     [:title, 'A'],
  #     [:original_title, 'B'],
  #     [:series_name, 'C'],
  #     [:tsearch_vector, 'D']
  #   ],
  #   :using => {
  #     :tsearch => {:prefix => true, :tsvector_column => :tsearch_vector},
  #     :trigram => {:threshold => 0.15}
  #   },
  #   :ignoring => :accents

  # pg_search_scope :search_fast,
  #   :against => [
  #     [:tsearch_vector],
  #   ],
  #   :using => {
  #     :tsearch => {:prefix => true, :tsvector_column => :tsearch_vector},
  #   }

  after_validation :calculate_search_terms, :if => :recalculate_search_terms?

  include PublicActivity::Common

  def language
    LANGUAGES[read_attribute(:language).to_i].to_s if read_attribute(:language)
  end

  def original_language
    LANGUAGES[read_attribute(:original_language).to_i].to_s if read_attribute(:original_language)
  end

  def main_author(reversed=false)
    if collective_work?
      I18n.t('books.collective_work')
    else
      if writers.first.present?
        return writers.first.fullname if not reversed
        return writers.first.fullname_reversed if reversed
      end
    end
  end

  def short_description(max_chars=350)
    if description.present? and description.length<=max_chars
      description.html_safe
    elsif description.present? and description.length>max_chars
      (description[0...max_chars]+'...').html_safe
    else
      nil
    end
  end


  # Returns book cover url if there is one or the default not image.
  def cover
    if image.present?
      image
    else
      "https://bookopolis.com/img/no_book_cover.jpg"
    end
  end

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :slugged_name,
      [:slugged_name, :id],
    ]
  end

  def slugged_name(opts={})
    opts[:max_expansions] ||= 1
    opts[:dashes] = true if opts[:dashes].nil?
    join_with = opts[:dashes] ? '-' : ' '

    converter = Greeklish.converter(max_expansions: opts[:max_expansions], generate_greek_variants: false)
    name_to_slug = ApplicationController.helpers.detone(UnicodeUtils.downcase(title).gsub('ς','σ').gsub(/[,.:'·-]/,''))
    name_to_slug.split(" ").map do |word|
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
    record = MARC::Record.new()
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
    if pages.present?
      if pages < 100
        "< 100"
      elsif pages >= 100 && pages < 300
        "100 - 300"
      elsif pages >= 300 && pages < 600
        "300 - 600"
      elsif pages >= 600 && pages < 1000
        "600 - 1000"
      else
        "> 1000"
      end
    end
  end

  def write_series_id
    if series_name.present?
      series_obj = Series.find_or_create_by(name: series_name)
      write_attribute(:series_id, series_obj.id)
    end
  end

end

