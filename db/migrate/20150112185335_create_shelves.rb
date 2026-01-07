class CreateShelves < ActiveRecord::Migration[5.2]
  def change
    create_table :shelves do |t|
      t.string :name
      t.integer :privacy, :default => 0
      t.boolean :built_in, :default => false
      t.integer :default_name, :default => 0
      t.boolean :active, :default => true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :shelves, :users
  end
end
