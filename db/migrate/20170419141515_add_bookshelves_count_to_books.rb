class AddBookshelvesCountToBooks < ActiveRecord::Migration
  def change
    add_column :books, :bookshelves_count, :integer, default: 0
  end
end
