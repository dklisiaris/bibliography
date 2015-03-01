class Profile < ActiveRecord::Base
  belongs_to :user

  enum account_type: %i(Προσωπικός Οργανισμός)
  enum privacy: %i(Δημόσιος Ιδιωτικός)  
  enum language: %i(Ελληνικά English)
  enum email_privacy: %i(Ποτέ Σε\ φίλους\ μόνο Σε\ συνδεδεμένους\ χρήστες Σε\ όλους)

  validates :username, presence: true, uniqueness: true

  def gravatar
    if avatar and not avatar.empty?
      avatar
    else
      gravatar_id = Digest::MD5::hexdigest(user.email).downcase
      "http://gravatar.com/avatar/#{gravatar_id}.png"
    end
  end

end
