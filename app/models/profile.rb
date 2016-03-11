class Profile < ActiveRecord::Base
  belongs_to :user

  mount_uploader :avatar, AvatarUploader
  mount_uploader :cover, CoverUploader

  enum account_type: %i(Προσωπικός Οργανισμός)
  enum privacy: %i(Δημόσιος Ιδιωτικός)  
  enum language: %i(Ελληνικά English)
  enum email_privacy: %i(Ποτέ Σε\ φίλους\ μόνο Σε\ συνδεδεμένους\ χρήστες Σε\ όλους)

  validates :username, presence: true, uniqueness: true

  def gravatar
    if avatar_url and not avatar_url.nil?
      avatar_url
    else
      gravatar_id = Digest::MD5::hexdigest(user.email).downcase
      "http://gravatar.com/avatar/#{gravatar_id}.png"
    end
  end

  def cover_safe
    return cover_url unless cover_url.nil?
    return "placeholders/layout/cover.jpg"
  end

end
