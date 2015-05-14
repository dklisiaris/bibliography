class Bookshelf < ActiveRecord::Base
  belongs_to :book
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
