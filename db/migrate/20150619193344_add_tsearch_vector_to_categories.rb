class AddTsearchVectorToCategories < ActiveRecord::Migration[5.2]
  def self.up
    add_column :categories, :tsearch_vector, :tsvector
    execute "CREATE INDEX categories_tsearch_idx
              ON categories
              USING gin(tsearch_vector);"                 
  end

  def self.down
    remove_column :categories, :tsearch_vector        
  end
end
