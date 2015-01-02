class User < ActiveRecord::Base
  royce_roles %w[ registered editor admin ]
  after_create :assign_default_role

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_create :assign_default_role

  private

  def assign_default_role
    add_role :registered
  end         

end
