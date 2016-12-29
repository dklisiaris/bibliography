class AddSocialToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :social, :hstore
  end
end
