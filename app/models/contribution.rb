class Contribution < ActiveRecord::Base
  belongs_to :book
  belongs_to :author, :counter_cache => true

  enum job: %i(συγγραφή μετάφραση ερμηνεία εικονογράφηση φωτογραφία επιμέλεια συνθέση στιχουργία εισήγηση διασκευή ανθολογία Φορέας Οργανισμός επιμέλεια\ σειράς επιμέλεια\ υποσειράς αφήγηση Ζωγράφος Γλύπτης Καλλιτέχνης κείμενα)

  default_scope { order('job') }
  scope :writers, -> { where(job: 0) }
  scope :contributors, -> { where.not(job: 0) }

  validates :book, presence: true
  validates :author, presence: true
  validates :job, presence: true

end
