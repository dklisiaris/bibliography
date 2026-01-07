class AddImpressionsCountToPublishers < ActiveRecord::Migration[5.2]
  def change
    add_column :publishers, :impressions_count, :integer, :default => 0
  end
end
