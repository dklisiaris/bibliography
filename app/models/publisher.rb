class Publisher < ActiveRecord::Base
  has_many :places, as: :placeable
  has_many :books

  # Log impressions filtered by ip
  is_impressionable :counter_cache => true, :unique => true

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]  

  searchkick batch_size: 50, 
  callbacks: :async, 
  word_start: ['name'],
  # text_middle: [:owner],
  # word_start: [:name, :owner],
  autocomplete: ['name']

  def search_data
    {
      name: name,
      owner: owner
    }
  end

  # Try building a slug based on the following fields in
  # increasing order of specificity.
  def slug_candidates
    [
      :slugged_name,
      [:slugged_name, :id],
    ]
  end  

  def slugged_name
    converter = Greeklish.converter(max_expansions: 1,generate_greek_variants: false)
    name_to_slug = ApplicationController.helpers.detone(UnicodeUtils.downcase(name).gsub('ς','σ').gsub(/[,.]/,''))
    name_to_slug.split(" ").map do |word|
      converted = converter.convert(word)
      converted.present? ? converted.last : word
    end.join('-')
  end    
end
