class AddPublicationVersionToBooks < ActiveRecord::Migration
  def change
    add_column :books, :publication_version, :integer
  end
end
