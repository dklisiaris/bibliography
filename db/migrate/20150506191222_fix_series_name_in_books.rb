class FixSeriesNameInBooks < ActiveRecord::Migration[5.2]
  def change
    rename_column :books, :series, :series_name
  end
end
