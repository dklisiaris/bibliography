class AddCollectiveWorkToBooks < ActiveRecord::Migration
  def change
    add_column :books, :collective_work, :boolean, default: false
  end
end
