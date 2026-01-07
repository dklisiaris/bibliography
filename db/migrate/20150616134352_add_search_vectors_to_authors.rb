class AddSearchVectorsToAuthors < ActiveRecord::Migration[5.2]
  def self.up
    add_column :authors, :tsearch_vector, :tsvector
    execute "CREATE INDEX authors_tsearch_idx
              ON authors
              USING gin(tsearch_vector);"                 
  end

  def self.down
    remove_column :authors, :tsearch_vector        
  end

end
