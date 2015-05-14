class Bookshelf < ActiveRecord::Base
  belongs_to :book
  belongs_to :shelf

  validates_uniqueness_of :book_id, scope: [:shelf_id]
  default_scope { order('created_at DESC') }

  def self.add_book_to_multiple_bookshelves(book_id, shelf_ids)    
    bookshelves_to_add = shelf_ids.map do |shelf_id| 
      {shelf_id: shelf_id, book_id: book_id}
    end if shelf_ids.present? and book_id.present?

    self.create bookshelves_to_add
  end

  def self.remove_book_from_multiple_bookshelves(book_id, shelf_ids)    
    self.where(book_id: book_id, shelf_id: shelf_ids).destroy_all if shelf_ids.present? and book_id.present?
  end
end
