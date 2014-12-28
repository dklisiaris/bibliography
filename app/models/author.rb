class Author < ActiveRecord::Base
  validates :lastname, presence: true
  
end
