class AddSocialToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :social, :hstore
  end
end
