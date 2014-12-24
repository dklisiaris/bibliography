class Category < ActiveRecord::Base
  extend ActsAsTree::TreeWalker

  acts_as_tree order: "ddc"
  

end
