class Category < ActiveRecord::Base
  extend ActsAsTree::TreeWalker
  acts_as_tree order: "ddc"

  validates :name, presence: true, :uniqueness => { scope: :ddc, message: 'This category already exists'}
  validates :ddc, presence: true    
  validates_with ParentValidator
    
end
