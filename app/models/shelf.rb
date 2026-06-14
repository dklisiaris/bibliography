class Shelf < ActiveRecord::Base
  include Recommendable
  
  belongs_to :user

  has_many :bookshelves
  has_many :books, through: :bookshelves
  has_many :ratings, as: :rateable

  enum :privacy, { same_as_profile: 0, is_public: 1, is_private: 2 }
  enum :default_name, {
    my_library: 0, want_to_read: 1, favourites: 2,
    currently_reading: 3, read_but_not_own: 4, to_read: 5
  }

  scope :built_in, -> { where(built_in: true) }
  scope :user_created, -> { where(built_in: false) }

  def screen_name
    return name if name.present? and not built_in?

    return I18n.t('shelves.' + default_name) if built_in?
  end

  def screen_privacy
    I18n.t('shelves.privacy.'+ privacy)
  end

  def self.humanize_privacy(privacy_symbol)
    I18n.t('shelves.privacy.'+ privacy_symbol) if privacy_symbol.present?
  end

end

# == Schema Information
#
# Table name: shelves
#
#  id           :integer          not null, primary key
#  name         :string
#  privacy      :integer          default("same_as_profile")
#  built_in     :boolean          default(FALSE)
#  default_name :integer          default("my_library")
#  active       :boolean          default(TRUE)
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_shelves_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
