class AddTsearchVectorToBooks < ActiveRecord::Migration
  def self.up
    add_column :books, :tsearch_vector, :tsvector
    execute "CREATE INDEX books_tsearch_idx
              ON books
              USING gin(tsearch_vector);"                 
  end

  def self.down
    remove_column :books, :tsearch_vector        
  end
end
