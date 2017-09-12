class Shelf < ActiveRecord::Base
  belongs_to :user

  has_many :bookshelves
  has_many :books, through: :bookshelves

  enum privacy: %i(same_as_profile is_public is_private)
  enum default_name: %i(my_library want_to_read favourites currently_reading read_but_not_own to_read)

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
#  privacy      :integer          default(0)
#  built_in     :boolean          default(FALSE)
#  default_name :integer          default(0)
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
