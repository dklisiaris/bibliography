class User < ActiveRecord::Base
  royce_roles %w[ registered editor admin ]
  before_save :ensure_api_key
  # before_create :assign_api_key
  after_create :assign_default_role, :assign_profile, :assign_built_in_shelves, :send_signup_email

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :async, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook, :google_oauth2]

  has_one :profile, :dependent => :destroy
  has_many :shelves, :dependent => :destroy
  has_many :bookshelves, through: :shelves
  has_many :books, -> { distinct }, through: :shelves
  has_many :writers, through: :books
  has_many :comments
  has_many :activities, as: :owner, class_name: 'PublicActivity::Activity', dependent: :destroy


  recommends :books, :shelves, :authors, :categories

  acts_as_follower
  acts_as_followable

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      # user.name = auth.info.name   # assuming the user model has a name
      # user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  # after_create :assign_default_role
  def screen_name
    if profile.name.present?
      name = profile.name
    elsif profile.username.present?
      name = profile.username
    else
      name = email
    end
  end

  def avatar
    profile.gravatar
  end

  def added_book?(book)
    bookshelves.where(book: book).count > 0
  end

  def book_in_which_collections(book)
    bookshelves.where(book: book).includes(:shelf).map {|bookshelf| bookshelf.shelf}
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

  def token
    api_key
  end

  def credentials
    return JSON.generate({ email: email, token: api_key })
  end

  # User is considered a newbie if she registered less than 5 days ago
  # or has signed in less than 10 times
  def newbie?
    ((Time.now - created_at).to_i / 86400) < 5 || sign_in_count < 10
  end

  private

  def assign_api_key
    write_attribute(:api_key, self.class.generate_api_key)
  end

  def assign_default_role
    add_role :registered
  end

  def assign_profile
    username = email.gsub(/@.+\z/, '')
    loop do
      break username unless Profile.where(username: username).exists?
      username = email.gsub(/@.+\z/, rand(100000).to_s)
    end
    create_profile(username: username)
  end

  # Creates and assigns the six built in shelves to user.
  # TODO Find a more elegant way to do this.
  def assign_built_in_shelves
    6.times do |i|
      shelves.create(built_in: true, default_name: i)
    end
  end

  def send_signup_email
    AccountNotifier.send_signup_email(self).deliver_later
  end

end
