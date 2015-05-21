class AddImpressionsCountToPublishers < ActiveRecord::Migration
  def change
    add_column :publishers, :impressions_count, :integer, :default => 0
  end
end
