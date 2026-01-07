class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :ddc
      t.string :slug
      t.integer :biblionet_id
      t.integer :parent_id

      t.timestamps null: false
    end
    add_index :categories, :parent_id
  end
end
