class AddImpressionsCountToAuthors < ActiveRecord::Migration
  def change
    add_column :authors, :impressions_count, :integer, :default => 0
  end
end
