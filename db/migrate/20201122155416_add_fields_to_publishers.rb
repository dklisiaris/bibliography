class AddFieldsToPublishers < ActiveRecord::Migration[5.2]
  def change
    add_column :publishers, :alternative_name, :string
    add_column :publishers, :address, :string
    add_column :publishers, :telephone, :string
    add_column :publishers, :email, :string
    add_column :publishers, :website, :string
  end
end
