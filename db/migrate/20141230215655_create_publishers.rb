class CreatePublishers < ActiveRecord::Migration[5.2]
  def change
    create_table :publishers do |t|
      t.string :name
      t.string :owner

      t.timestamps null: false
    end
  end
end
