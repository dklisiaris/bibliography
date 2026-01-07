class CreateBooksCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :books_categories, id: false do |t|
      t.belongs_to  :book, index: true
      t.belongs_to  :category, index: true
    end    
    add_foreign_key :books_categories, :books
    add_foreign_key :books_categories, :categories
  end
end
