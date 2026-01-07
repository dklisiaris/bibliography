class AddBookshelvesCountToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :bookshelves_count, :integer, default: 0
  end
end
