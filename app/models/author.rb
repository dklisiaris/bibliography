class Author < ActiveRecord::Base
  validates :lastname, presence: true

  has_many :awards, as: :awardable
  has_many :prizes, through: :awards  

  def fullname
    [firstname, lastname].join(' ')
  end
  
end
