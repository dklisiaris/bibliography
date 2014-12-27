class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.string :firstname
      t.string :lastname
      t.string :lifetime
      t.text :biography
      t.string :image

      t.timestamps null: false
    end
  end
end
