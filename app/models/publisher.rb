class Publisher < ActiveRecord::Base
  validates :biblionet_id, uniqueness: true
  validates :name, presence: true

  has_many :places, as: :placeable
  has_many :books

  # Log impressions filtered by ip
  # is_impressionable :counter_cache => true, :unique => true # Disabled - gem causing errors

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

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

  after_validation :calculate_search_terms, :if => :name_changed?

  # Try building a slug based on the following fields in increasing order of specificity.
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
    write_attribute(:tsearch_vector, slugged_name(max_expansions: 3, dashes: false))
  end
end

# == Schema Information
#
# Table name: publishers
#
#  id                :integer          not null, primary key
#  name              :string
#  owner             :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  biblionet_id      :integer
#  impressions_count :integer          default(0)
#  slug              :string
#  tsearch_vector    :tsvector
#  books_count       :integer          default(0)
#  alternative_name  :string
#  address           :string
#  telephone         :string
#  email             :string
#  website           :string
#
# Indexes
#
#  index_publishers_on_slug  (slug) UNIQUE
#  publishers_tsearch_idx    (tsearch_vector) USING gin
#
