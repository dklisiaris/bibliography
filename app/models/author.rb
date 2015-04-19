class Author < ActiveRecord::Base
  validates :lastname, presence: true

  has_many :contributions
  has_many :books, through: :contributions
  has_many :awards, as: :awardable
  has_many :prizes, through: :awards  

  enum job: %i(Συγγραφέας Μεταφραστής Ερμηνευτής Εικονογράφος Φωτογράφος Επιμελητής Συνθέτης Στιχουργός Εισηγητής Διασκευαστής Ανθολόγος Φορέας Οργανισμός Υπεύθυνος\ Σειράς Υπεύθυνος\ Υποσειράς Αφηγητής Ζωγράφος Γλύπτης Καλλιτέχνης)

  def fullname
    return [firstname, lastname].join(' ') if firstname.present?
    return lastname
  end
  
end
