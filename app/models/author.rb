class Author < ActiveRecord::Base
  validates :lastname, presence: true

  has_many :awards
  has_many :prizes, through: :awards

  def fullname
    [firstname, lastname].join(' ')
  end
  
end
