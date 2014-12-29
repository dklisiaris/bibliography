class Prize < ActiveRecord::Base

  has_many :author_awards
  has_many :authors, through: :author_awards
end
