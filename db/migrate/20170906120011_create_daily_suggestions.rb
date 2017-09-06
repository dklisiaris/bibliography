class CreateDailySuggestions < ActiveRecord::Migration
  def change
    create_table :daily_suggestions do |t|
      t.integer :book_id
      t.timestamp :suggested_at
      t.integer :suggested_count, default: 0
    end
    add_index :daily_suggestions, :book_id, unique: true
  end
end
