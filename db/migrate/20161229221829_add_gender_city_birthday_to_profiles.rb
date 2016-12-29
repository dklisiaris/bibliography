class AddGenderCityBirthdayToProfiles < ActiveRecord::Migration
  def change
    add_column :profiles, :gender, :integer
    add_column :profiles, :city, :string
    add_column :profiles, :birthday, :datetime
  end
end
