class Category < ActiveRecord::Base
  extend ActsAsTree::TreeWalker
  acts_as_tree order: "ddc"

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  has_and_belongs_to_many :books
  has_many :ratings, as: :rateable
  before_destroy { books.clear }

  validates :name, presence: true, :uniqueness => { scope: :ddc, message: 'This category already exists'}
  validates :ddc, presence: true
  validates_with ParentValidator

  scope :featured, -> { where(featured: true) }

  # Log impressions filtered by ip
  is_impressionable :counter_cache => true, :unique => true

  searchkick batch_size: 100,
  callbacks: :async,
  match: :word_start,
  searchable: [:tsearch_vector],
  word_start: [:tsearch_vector]

  def search_data
  {
    tsearch_vector: tsearch_vector.gsub("'", "").split(" "),
  }
  end

  # include PgSearch
  # pg_search_scope :search_by_name,
  #   :against => [
  #     [:name, 'A'],
  #     [:ddc, 'B'],
  #     [:tsearch_vector, 'C']
  #   ],
  #   :using => {
  #     :tsearch => {:prefix => true, :tsvector_column => :tsearch_vector},
  #     :trigram => {:threshold => 0.15}
  #   },
  #   :ignoring => :accents

  after_validation :calculate_search_terms, :if => :recalculate_search_terms?

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
    name_to_slug = ApplicationController.helpers.detone(UnicodeUtils.downcase(name).gsub('ς','σ').gsub(/[,.:'·-]/,''))
    name_to_slug.split(" ").map do |word|
      converted = converter.convert(word)
      converted.present? ? converted : word
    end.flatten.uniq.join(join_with)
  end

  def calculate_search_terms
    write_attribute(:tsearch_vector, slugged_name(max_expansions: 3, dashes: false) + ' ' + ddc)
  end

  def recalculate_search_terms?
    :name_changed? || :ddc_changed?
  end

  def get_popular_books(limit=10)
    Rails.cache.fetch("#{cache_key}/get_popular_books", expires_in: 7.days) do
      books.where(id: get_popular_book_ids(limit))
    end
  end

  def get_popular_book_ids(limit=10)
    Rails.cache.fetch("#{cache_key}/get_popular_books", expires_in: 7.days) do
      books.order(impressions_count: :desc, image: :asc).limit(limit).ids
    end
  end

  def get_random_books(limit=12)
    Rails.cache.fetch("#{cache_key}/get_random_books", expires_in: 2.days) do
      books.where(id: get_random_book_ids(limit))
    end
  end

  def get_random_book_ids(limit=12)
    Rails.cache.fetch("#{cache_key}/get_random_books", expires_in: 2.days) do
      books.where.not(image: nil).order("RANDOM()").limit(limit).ids
    end
  end

end

# == Schema Information
#
# Table name: categories
#
#  id                :integer          not null, primary key
#  name              :string
#  ddc               :string
#  slug              :string
#  biblionet_id      :integer
#  parent_id         :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  impressions_count :integer          default(0)
#  featured          :boolean          default(FALSE)
#  tsearch_vector    :tsvector
#
# Indexes
#
#  categories_tsearch_idx         (tsearch_vector)
#  index_categories_on_parent_id  (parent_id)
#  index_categories_on_slug       (slug) UNIQUE
#
