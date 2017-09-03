class AddUploadedCoverToBooks < ActiveRecord::Migration
  def change
    add_column :books, :uploaded_cover, :string
  end
end
