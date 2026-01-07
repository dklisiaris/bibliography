class AddCollectiveWorkToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :collective_work, :boolean, default: false
  end
end
