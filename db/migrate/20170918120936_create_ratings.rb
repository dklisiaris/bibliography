class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.integer :user_id, :null => false
      t.references :rateable, :polymorphic => true, :null => false
      t.integer :rate, :null => false
      t.boolean :bookmark, default: false
    end
    add_index :ratings, :user_id
    add_index :ratings, ["rateable_id", "rateable_type"], :name => "fk_rateables"
  end
end
