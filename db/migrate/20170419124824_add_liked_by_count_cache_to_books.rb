class AddLikedByCountCacheToBooks < ActiveRecord::Migration
  def change
    add_column :books, :liked_by_count_cache, :integer, default: 0
    add_column :books, :disliked_by_count_cache, :integer, default: 0
  end
end
