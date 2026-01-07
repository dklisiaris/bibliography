class AddViewsCountToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :views_count, :integer, default: 0
  end
end
