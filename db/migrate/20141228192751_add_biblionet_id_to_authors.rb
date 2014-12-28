class AddBiblionetIdToAuthors < ActiveRecord::Migration
  def change
    add_column :authors, :biblionet_id, :integer
  end
end
