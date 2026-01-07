class AddBiblionetIdToPublisher < ActiveRecord::Migration[5.2]
  def change
    add_column :publishers, :biblionet_id, :integer
  end
end
