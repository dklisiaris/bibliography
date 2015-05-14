class AddIndexToBookshelf < ActiveRecord::Migration
  def change
    add_index :bookshelves, [:book_id, :shelf_id], unique: true
  end
end
