class AddUploadedAvatarToAuthors < ActiveRecord::Migration
  def change
    add_column :authors, :uploaded_avatar, :string
  end
end
