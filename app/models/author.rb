class Author < ActiveRecord::Base
  include Recommendable
  
  validates :lastname, presence: true

  mount_uploader :uploaded_avatar, AuthorAvatarUploader

  has_many :contributions
  has_many :books, through: :contributions
  has_many :writings, -> { where(contributions: { job: 0 }) }, :through => :contributions, source: 'book'
  has_many :contributed_books, -> { where.not(contributions: { job: 0 }) }, :through => :contributions, source: 'book'
  has_many :awards, as: :awardable
  has_many :prizes, through: :awards
  belongs_to :masterpiece, class_name: 'Book', optional: true
  has_many :ratings, as: :rateable
  has_many :impressions, as: :impressionable, dependent: :destroy

  enum job: %i(Συγγραφέας Μεταφραστής Ερμηνευτής Εικονογράφος Φωτογράφος Επιμελητής Συνθέτης Στιχουργός Εισηγητής Διασκευαστής Ανθολόγος Φορέας Οργανισμός Υπεύθυνος\ Σειράς Υπεύθυνος\ Υποσειράς Αφηγητής Ζωγράφος Γλύπτης Καλλιτέχνης Κειμενογράφος)

  # Log impressions filtered by ip
  # is_impressionable :counter_cache => true, :unique => true # Disabled - gem causing errors

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  scope :writers, -> { joins(:contributions).where(contributions:{job: 0}).group("authors.id").order("authors.created_at DESC") }
  scope :with_biography, -> { where.not(biography: "") }

  after_validation :calculate_search_terms, :if => :name_changed?
  before_save :write_mastepiece_id

  searchkick batch_size: 100,
             callbacks: :async,
             match: :word_start,
             searchable: [:tsearch_vector],
             word_start: [:tsearch_vector]
             # autocomplete: ['title']

  def search_data
    {
      tsearch_vector: tsearch_vector.gsub("'", '').split(' ')
    }
  end

  def fullname
    return [firstname, lastname].join(' ') if firstname.present?

    lastname
  end

  def fullname_reversed
    return [lastname, firstname].join(', ') if firstname.present?

    lastname
  end

  def name_changed?
    :lastname_changed? || :firstname_changed?
  end

  def short_biography(max_chars = 350)
    if biography.present? && biography.length <= max_chars
      biography.html_safe
    elsif biography.present? && biography.length > max_chars
      "#{biography[0...max_chars]}...".html_safe
    end
  end

  def avatar
    if uploaded_avatar_url.present?
      uploaded_avatar_url
    else
      AuthorAvatarUploadWorker.perform_async(id) if image.present?
      '/no_avatar.jpg'
    end
  end

  # Try building a slug based on the following fields in increasing order of specificity.
  def slug_candidates
    [
      :slugged_name,
      %i[slugged_name id]
    ]
  end

  def slugged_name(opts={})
    opts[:max_expansions] ||= 1
    opts[:dashes] = true if opts[:dashes].nil?
    join_with = opts[:dashes] ? '-' : ' '

    converter = Greeklish.converter(max_expansions: opts[:max_expansions], generate_greek_variants: false)
    name_to_slug = ApplicationController.helpers.detone(UnicodeUtils.downcase(fullname).gsub('ς','σ').gsub(/[,.:'·-]/,''))
    name_to_slug.split(" ").map do |word|
      converted = converter.convert(word)
      converted.present? ? converted : word
    end.flatten.uniq.join(join_with)
  end

  def calculate_search_terms
    write_attribute(:tsearch_vector, slugged_name(max_expansions: 3, dashes: false))
  end

  def associated_dates
    years_re = /\d+-\d*/
    return extra_info.split(',').select{|part| part =~ years_re}.join.strip if extra_info.present?

    nil
  end

  def associated_titles
    years_re = /\d+-\d*/
    return extra_info.split(',').reject{|part| part =~ years_re}.join(',').strip if extra_info.present?

    nil
  end

  def self.get_random_awarded
    Rails.cache.fetch('get_random_awarded_authors', expires_in: 1.day) do
      includes(:masterpiece).where(id: Award.random_awarded_author_ids).where.not(masterpiece_id: nil)
    end
  end

  def write_mastepiece_id
    write_attribute(:masterpiece_id, books.first.id) unless books.blank?
  end
end

# == Schema Information
#
# Table name: authors
#
#  id                  :integer          not null, primary key
#  firstname           :string
#  lastname            :string
#  extra_info          :string
#  biography           :text
#  image               :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  biblionet_id        :integer
#  impressions_count   :integer          default(0)
#  slug                :string
#  tsearch_vector      :tsvector
#  contributions_count :integer          default(0)
#  uploaded_avatar     :string
#  masterpiece_id      :integer
#  middle_name         :string
#  born_year           :integer
#  death_year          :integer
#
# Indexes
#
#  authors_tsearch_idx              (tsearch_vector) USING gin
#  index_authors_on_biblionet_id    (biblionet_id) UNIQUE
#  index_authors_on_masterpiece_id  (masterpiece_id)
#  index_authors_on_slug            (slug) UNIQUE
#
