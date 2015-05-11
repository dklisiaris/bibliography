class Bookshelf < ActiveRecord::Base
  belongs_to :book
  belongs_to :shelf

  default_scope { order('created_at DESC') }
end
