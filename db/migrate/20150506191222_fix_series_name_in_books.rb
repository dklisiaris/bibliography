class FixSeriesNameInBooks < ActiveRecord::Migration
  def change
    rename_column :books, :series, :series_name
  end
end
