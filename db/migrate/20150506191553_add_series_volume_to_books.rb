class AddSeriesVolumeToBooks < ActiveRecord::Migration
  def change
    add_column :books, :series_volume, :integer
  end
end
