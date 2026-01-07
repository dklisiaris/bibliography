class AddBiblionetIdToAuthors < ActiveRecord::Migration[5.2]
  def change
    add_column :authors, :biblionet_id, :integer
  end
end
