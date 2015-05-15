class AddImpressionsCountToBooks < ActiveRecord::Migration
  def change    
    add_column :books, :impressions_count, :integer, :default => 0    
  end
end
