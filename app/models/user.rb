class User < ActiveRecord::Base
  royce_roles %w[ registered editor admin ]
  after_create :assign_default_role, :assign_profile

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :profile, :dependent => :destroy

  # after_create :assign_default_role
  def screen_name
    name = profile.name ||= profile.username ||= email 
  end

  def avatar
    profile.gravatar
  end

  private

  def assign_default_role
    add_role :registered
  end         

  def assign_profile
    create_profile(username: email.gsub(/@.+\z/, id.to_s))
  end

end
