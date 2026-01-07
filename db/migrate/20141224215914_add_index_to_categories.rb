class AddIndexToCategories < ActiveRecord::Migration[5.2]
  def change
    add_index :categories, :slug, unique: true
  end
end
