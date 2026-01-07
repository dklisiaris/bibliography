class AddUploadedCoverToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :uploaded_cover, :string
  end
end
