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

# == Schema Information
#
# Table name: contributions
#
#  id         :integer          not null, primary key
#  job        :integer
#  book_id    :integer
#  author_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_contributions_on_author_id  (author_id)
#  index_contributions_on_book_id    (book_id)
#
# Foreign Keys
#
#  fk_rails_...  (author_id => authors.id)
#  fk_rails_...  (book_id => books.id)
#
