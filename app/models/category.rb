class Category < ActiveRecord::Base
  extend ActsAsTree::TreeWalker
  acts_as_tree order: "ddc"

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]  

  has_and_belongs_to_many :books
  before_destroy { books.clear }

  validates :name, presence: true, :uniqueness => { scope: :ddc, message: 'This category already exists'}
  validates :ddc, presence: true    
  validates_with ParentValidator

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
    name_to_slug = UnicodeUtils.downcase(ApplicationController.helpers.detone(name).gsub('ς','σ').gsub('.',''))
    name_to_slug.split(" ").map do |word|
      converted = converter.convert(word)
      converted.present? ? converted.last : word
    end.join('-')
  end
    
end
