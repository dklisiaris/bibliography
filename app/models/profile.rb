class Profile < ActiveRecord::Base
  belongs_to :user

  mount_uploader :avatar, AvatarUploader
  mount_uploader :cover, CoverUploader

  enum gender: %i(male female other)
  enum account_type: %i(Προσωπικός Οργανισμός)
  enum privacy: %i(is_public is_private)
  enum language: %i(Ελληνικά English)
  enum email_privacy: %i(Ποτέ Σε\ φίλους\ μόνο Σε\ συνδεδεμένους\ χρήστες Σε\ όλους)

  validates :username, presence: true, uniqueness: true

  hstore_accessor :social,
    website: { data_type: :string, store_key: "wb" },
    facebook: { data_type: :string, store_key: "fb" },
    twitter: { data_type: :string, store_key: "tt" },
    googleplus: { data_type: :string, store_key: "gp" },
    pinterest: { data_type: :string, store_key: "pt" },
    goodreads: { data_type: :string, store_key: "gr" },
    librarything: { data_type: :string, store_key: "lt" }

  def gravatar
    if avatar_url and not avatar_url.nil?
      avatar_url
    else
      gravatar_id = Digest::MD5::hexdigest(user.email).downcase
      "https://gravatar.com/avatar/#{gravatar_id}.png"
    end
  end

  def cover_safe
    return cover_url unless cover_url.nil?
    return "placeholders/layout/cover.jpg"
  end

  def social_any?
    facebook.present? || twitter.present? || googleplus.present? || pinterest.present?
  end

  def details_any?
    gender.present? || city.present? || birthday.present?
  end

  def screen_gender
    I18n.t('gender.'+ gender) if gender.present?
  end

  def details
    [screen_gender, age, city].reject(&:blank?).join(', ')
  end

  def age
    if birthday.present?
      now = Time.now.utc.to_date
      now.year - birthday.year - ((now.month > birthday.month ||
        (now.month == birthday.month && now.day >= birthday.day)) ? 0 : 1)
    end
  end

  def self.humanize_gender(gender_symbol)
    I18n.t('gender.'+ gender_symbol) if gender_symbol.present?
  end

  def self.humanize_privacy(privacy_symbol)
    I18n.t('profile.privacy.'+ privacy_symbol) if privacy_symbol.present?
  end

end

# == Schema Information
#
# Table name: profiles
#
#  id                    :integer          not null, primary key
#  username              :string
#  name                  :string
#  avatar                :string
#  cover                 :string
#  about_me              :text
#  about_library         :text
#  account_type          :integer          default(0)
#  privacy               :integer          default(0)
#  language              :integer          default(0)
#  allow_comments        :boolean          default(TRUE)
#  allow_friends         :boolean          default(TRUE)
#  email_privacy         :integer          default(0)
#  discoverable_by_email :boolean          default(TRUE)
#  receive_newsletters   :boolean          default(TRUE)
#  user_id               :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  social                :hstore
#  gender                :integer
#  city                  :string
#  birthday              :datetime
#
# Indexes
#
#  index_profiles_on_user_id   (user_id)
#  index_profiles_on_username  (username) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
