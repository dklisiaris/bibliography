class User < ActiveRecord::Base
  royce_roles %w[ registered editor admin ]
  before_save :ensure_api_key
  # before_create :assign_api_key
  after_create :assign_default_role, :assign_profile, :assign_built_in_shelves

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :async, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :profile, :dependent => :destroy
  has_many :shelves, :dependent => :destroy
  has_many :bookshelves, through: :shelves
  has_many :books, through: :shelves
  has_many :writers, through: :books

  recommends :books, :shelves, :authors, :categories

  acts_as_follower
  acts_as_followable

  # after_create :assign_default_role
  def screen_name
    name = profile.name ||= profile.username ||= email 
  end

  def avatar
    profile.gravatar
  end

  def added_book?(book)
    bookshelves.where(book: book).count > 0
  end

  def book_in_which_collections(book)
    bookshelves.where(book: book).map {|bookshelf| bookshelf.shelf}
  end

  

  def ensure_api_key
    if api_key.blank?
      self.api_key = self.class.generate_api_key
    end
  end

  def self.generate_api_key
    loop do
      # token = SecureRandom.base64.tr('0+/=', 'bRat')
      token = Devise.friendly_token
      break token unless User.exists?(api_key: token)
    end
  end

  private

  def assign_api_key    
    write_attribute(:api_key, self.class.generate_api_key)
  end

  def assign_default_role
    add_role :registered
  end         

  def assign_profile
    create_profile(username: email.gsub(/@.+\z/, id.to_s))
  end

  # Creates and assigns the six built in shelves to user.
  # TODO Find a more elegant way to do this.
  def assign_built_in_shelves
    6.times do |i|
      shelves.create(built_in: true, default_name: i)
    end
  end

end
