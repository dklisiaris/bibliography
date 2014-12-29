class Prize < ActiveRecord::Base

  has_many :awards
  has_many :awards, through: :prizes
end
