class CreateAuthorAwards < ActiveRecord::Migration
  def change
    create_table :author_awards do |t|
      t.references :author, index: true
      t.references :prize, index: true
      t.integer :year

      t.timestamps null: false
    end
    add_foreign_key :author_awards, :authors
    add_foreign_key :author_awards, :prizes
  end
end
