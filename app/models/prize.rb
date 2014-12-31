class Prize < ActiveRecord::Base

  has_many :awards
  has_many :awarded_authors, through: :awards, source: :awardable, source_type: 'Author'
  # has_many :awarded_books, through: :awards, source: :awardable, source_type: 'Book'    
end
