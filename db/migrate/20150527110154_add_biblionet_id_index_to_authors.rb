class AddBiblionetIdIndexToAuthors < ActiveRecord::Migration[5.2]
  def change
    add_index :authors, :biblionet_id, unique: true
  end
end
