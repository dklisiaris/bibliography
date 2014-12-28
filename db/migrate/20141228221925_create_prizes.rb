class CreatePrizes < ActiveRecord::Migration
  def change
    create_table :prizes do |t|
      t.string :name

      t.timestamps null: false
    end
    add_index :prizes, :name, unique: true
  end
end
