class Author < ActiveRecord::Base
  validates :lastname, presence: true

  has_many :author_awards
  has_many :prizes, through: :author_awards

  def fullname
    [firstname, lastname].join(' ')
  end
  
end
