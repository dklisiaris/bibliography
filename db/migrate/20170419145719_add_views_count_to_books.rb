class AddViewsCountToBooks < ActiveRecord::Migration
  def change
    add_column :books, :views_count, :integer, default: 0
  end
end
