class ChangeLatlongTypeInPlaces < ActiveRecord::Migration[6.1]
  def self.up
    change_column :places, :latitude, :decimal, precision: 10, scale: 6
    change_column :places, :longitude, :decimal, precision: 10, scale: 6
  end
  
  def self.down
    change_column :places, :latitude, :float
    change_column :places, :longitude, :float
  end  
end
