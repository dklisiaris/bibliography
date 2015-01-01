class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.integer :job
      t.references :book, index: true
      t.references :author, index: true

      t.timestamps null: false
    end
    add_foreign_key :contributions, :books
    add_foreign_key :contributions, :authors
  end
end
