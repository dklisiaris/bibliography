class ChangeLatlongTypeInPlaces < ActiveRecord::Migration[5.2]
  def self.up
    change_table :places do |t|
      t.change :latitude, :decimal, {:precision=>10, :scale=>6}
      t.change :longitude, :decimal, {:precision=>10, :scale=>6}
    end
  end
  def self.down
    change_table :places do |t|
      t.change :latitude, :float
      t.change :longitude, :float
    end
  end  
end
