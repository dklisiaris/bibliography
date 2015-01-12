class Profile < ActiveRecord::Base
  belongs_to :user

  enum account_type: %i(Προσωπικός Οργανισμός)
  enum privacy: %i(Δημόσιος Ιδιωτικός)  
  enum language: %i(Ελληνικά English)
  enum email_privacy: %i(Ποτέ Σε\ φίλους\ μόνο Σε\ συνδεδεμένους\ χρήστες Σε\ όλους)
end
