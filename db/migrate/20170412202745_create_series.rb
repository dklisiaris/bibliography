class CreateSeries < ActiveRecord::Migration[5.2]
  def change
    create_table :series do |t|
      t.string :name
      t.integer :books_count, :default => 0
      t.tsvector :tsearch_vector

      t.timestamps null: false
    end
  end
end
