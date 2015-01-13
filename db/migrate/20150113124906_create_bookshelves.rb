class CreateBookshelves < ActiveRecord::Migration
  def change
    create_table :bookshelves do |t|
      t.references :book, index: true
      t.references :shelf, index: true

      t.timestamps null: false
    end
    add_foreign_key :bookshelves, :books
    add_foreign_key :bookshelves, :shelves
  end
end
