class AddGenderCityBirthdayToProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :gender, :integer
    add_column :profiles, :city, :string
    add_column :profiles, :birthday, :datetime
  end
end
