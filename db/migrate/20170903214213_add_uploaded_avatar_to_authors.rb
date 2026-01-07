class AddUploadedAvatarToAuthors < ActiveRecord::Migration[5.2]
  def change
    add_column :authors, :uploaded_avatar, :string
  end
end
