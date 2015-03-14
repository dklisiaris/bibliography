class Contribution < ActiveRecord::Base
  belongs_to :book
  belongs_to :author

  enum job: %i(Συγγραφέας Μετάφραση Ερμηνευτής Εικονογράφηση Φωτογραφία Επιμέλεια Συνθέτης Στιχουργός Εισήγηση Διασκευή Ανθολόγος Φορέας Οργανισμός Επιμέλεια\ Σειράς Επιμέλεια\ Υποσειράς Αφήγηση Ζωγράφος Γλύπτης Καλλιτέχνης)

  default_scope { order('job') }
  scope :writers, -> { where(job: 0) }
  scope :contributors, -> { where.not(job: 0) }

end
