class AddMasterpieceIdToAuthors < ActiveRecord::Migration[5.2]
  def change
    add_column :authors, :masterpiece_id, :integer
    add_index :authors, :masterpiece_id
  end
end
