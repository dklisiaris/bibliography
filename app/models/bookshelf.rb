class Bookshelf < ActiveRecord::Base
  belongs_to :book, :counter_cache => true
  belongs_to :shelf

  validates_uniqueness_of :book_id, scope: [:shelf_id]
  # default_scope { order('created_at DESC') }

  # TODO Find a better way (on activerecord layer) to save and remove multiple bookshelves
  # while making sure they belong to current user.
  # Currently all user.shelves ids are loaded so we check if shelf_ids to save are included.

  def self.add_book_to_multiple_bookshelves(book_id, shelf_ids, user)
    if shelf_ids.present? and book_id.present? and user.present?
      shelf_ids = JSON.parse(shelf_ids) if shelf_ids.kind_of?(String)

      # Load current user's shelves
      user_shelves_ids = user.shelves.pluck(:id)

      # Make sure shelf ids to be removed belong to current user's shelves
      bookshelves_to_add = shelf_ids.map do |shelf_id|
        {shelf_id: shelf_id.to_i, book_id: book_id} if user_shelves_ids.include? shelf_id.to_i
      end.compact

      self.create bookshelves_to_add
    end
  end

  def self.remove_book_from_multiple_bookshelves(book_id, shelf_ids, user)
    if shelf_ids.present? and book_id.present? and user.present?
      shelf_ids = JSON.parse(shelf_ids) if shelf_ids.kind_of?(String)

      # Load current user's shelves
      user_shelves_ids = user.shelves.pluck(:id)

      # Make sure shelf ids to be removed belong to current user's shelves
      shelf_ids = shelf_ids.map do |shelf_id|
        shelf_id.to_i if user_shelves_ids.include? shelf_id.to_i
      end.compact

      self.where(book_id: book_id, shelf_id: shelf_ids).destroy_all
    end
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
