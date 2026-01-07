class AddSeriesVolumeToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :series_volume, :integer
  end
end
