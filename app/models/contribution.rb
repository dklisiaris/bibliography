class Contribution < ActiveRecord::Base
  belongs_to :book
  belongs_to :author, :counter_cache => true

  enum :job, {
    συγγραφή: 0, μετάφραση: 1, ερμηνεία: 2, εικονογράφηση: 3, φωτογραφία: 4,
    επιμέλεια: 5, συνθέση: 6, στιχουργία: 7, εισήγηση: 8, διασκευή: 9, ανθολογία: 10,
    Φορέας: 11, Οργανισμός: 12,
    "επιμέλεια σειράς": 13, "επιμέλεια υποσειράς": 14,
    αφήγηση: 15, Ζωγράφος: 16, Γλύπτης: 17, Καλλιτέχνης: 18, κείμενα: 19
  }

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
