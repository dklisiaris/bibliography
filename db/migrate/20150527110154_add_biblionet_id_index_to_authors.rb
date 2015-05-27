class AddBiblionetIdIndexToAuthors < ActiveRecord::Migration
  def change
    add_index :authors, :biblionet_id, unique: true
  end
end
