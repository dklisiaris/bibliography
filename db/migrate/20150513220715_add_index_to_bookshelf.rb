class AddIndexToBookshelf < ActiveRecord::Migration[5.2]
  def change
    add_index :bookshelves, [:book_id, :shelf_id], unique: true
  end
end
