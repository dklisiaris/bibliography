class CreatePlaces < ActiveRecord::Migration[5.2]
  def change
    create_table :places do |t|
      t.string :name
      t.string :role
      t.string :address
      t.string :telephone
      t.string :fax
      t.string :email
      t.string :website
      t.float :latitude
      t.float :longitude
      t.belongs_to :placeable, polymorphic: true      

      t.timestamps null: false
    end
    add_index :places, [:placeable_id, :placeable_type]
  end
end
