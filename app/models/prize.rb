class Prize < ActiveRecord::Base

  has_many :awards
  has_many :authors, through: :awards, source: :awardable, source_type: 'Author'
  # has_many :awarded_books, through: :awards, source: :awardable, source_type: 'Book'    
end

# == Schema Information
#
# Table name: prizes
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_prizes_on_name  (name) UNIQUE
#
