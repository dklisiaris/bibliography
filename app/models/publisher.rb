class Publisher < ActiveRecord::Base
  validates :biblionet_id, uniqueness: true
  validates :name, presence: true

  has_many :places, as: :placeable
  has_many :books

  # Log impressions filtered by ip
  is_impressionable :counter_cache => true, :unique => true

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]  

  # searchkick batch_size: 50,
  # callbacks: :async, 
  # word_start: ['name'],
  # # text_middle: [:owner],
  # # word_start: [:name, :owner],
  # autocomplete: ['name']

  # def search_data
  #   {
  #     name: name,
  #     owner: owner
  #   }
  # end

  include PgSearch
  pg_search_scope :search_by_name, 
    :against => [
      [:name, 'A'],
      [:tsearch_vector, 'B']
    ], 
    :using => {
      :tsearch => {:prefix => true, :tsvector_column => :tsearch_vector},
      :trigram => {:threshold => 0.15}
    }, 
    :ignoring => :accents  

  after_validation :calculate_search_terms, :if => :name_changed?

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
    write_attribute(:tsearch_vector, slugged_name(max_expansions: 3, dashes: false))    
  end   
end
