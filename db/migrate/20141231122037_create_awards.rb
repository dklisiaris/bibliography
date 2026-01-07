class CreateAwards < ActiveRecord::Migration[5.2]
  def change
    create_table :awards do |t|
      t.references :prize, index: true
      t.integer :year
      t.belongs_to :awardable, polymorphic: true  

      t.timestamps null: false
    end
    add_index :awards, [:awardable_id, :awardable_type]
    add_foreign_key :awards, :prizes
  end
end
