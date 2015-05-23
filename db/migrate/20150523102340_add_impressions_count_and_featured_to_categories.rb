class AddImpressionsCountAndFeaturedToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :impressions_count, :integer, :default => 0
    add_column :categories, :featured, :boolean, default: false
  end
end
