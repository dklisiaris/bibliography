class AddImpressionsCountToAuthors < ActiveRecord::Migration[5.2]
  def change
    add_column :authors, :impressions_count, :integer, :default => 0
  end
end
