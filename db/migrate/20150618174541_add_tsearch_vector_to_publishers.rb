class AddTsearchVectorToPublishers < ActiveRecord::Migration
  def self.up
    add_column :publishers, :tsearch_vector, :tsvector
    execute "CREATE INDEX publishers_tsearch_idx
              ON publishers
              USING gin(tsearch_vector);"                 
  end

  def self.down
    remove_column :publishers, :tsearch_vector        
  end
end
