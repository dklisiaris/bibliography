class AddSeriesIdToBooks < ActiveRecord::Migration
  def change
    add_reference :books, :series, index: true, foreign_key: true
  end
end
