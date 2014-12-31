class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :subtitle
      t.text :description
      t.string :image
      t.string :isbn
      t.string :isbn13
      t.string :ismn
      t.string :issn
      t.string :series
      t.integer :pages
      t.integer :publication_year
      t.string :publication_place
      t.decimal :price, {:precision=>6, :scale=>2}
      t.date :price_updated_at
      t.string :physical_description
      t.integer :cover_type, default: 0
      t.integer :availability, default: 0
      t.integer :format, default: 0
      t.integer :original_language
      t.string :original_title
      t.references :publisher, index: true
      t.string :extra
      t.integer :biblionet_id

      t.timestamps null: false
    end
    add_index :books, :isbn, unique: true
    add_index :books, :isbn13, unique: true
    add_index :books, :ismn, unique: true
    add_foreign_key :books, :publishers
  end
end
