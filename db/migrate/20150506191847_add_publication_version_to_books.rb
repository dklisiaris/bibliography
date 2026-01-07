class AddPublicationVersionToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :publication_version, :integer
  end
end
