FactoryGirl.define do
  factory :contribution do
    job 1
book nil
author nil
  end

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
