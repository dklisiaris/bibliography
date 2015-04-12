class AddBiblionetIdToPublisher < ActiveRecord::Migration
  def change
    add_column :publishers, :biblionet_id, :integer
  end
end
