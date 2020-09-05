FactoryBot.define do
  factory :bookshelf do
    book nil
shelf nil
  end

end

# == Schema Information
#
# Table name: bookshelves
#
#  id         :integer          not null, primary key
#  book_id    :integer
#  shelf_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_bookshelves_on_book_id               (book_id)
#  index_bookshelves_on_book_id_and_shelf_id  (book_id,shelf_id) UNIQUE
#  index_bookshelves_on_shelf_id              (shelf_id)
#
# Foreign Keys
#
#  fk_rails_...  (book_id => books.id)
#  fk_rails_...  (shelf_id => shelves.id)
#
