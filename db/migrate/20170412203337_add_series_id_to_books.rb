class AddSeriesIdToBooks < ActiveRecord::Migration[5.2]
  def change
    add_reference :books, :series, index: true, foreign_key: true
  end
end
