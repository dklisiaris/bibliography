class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :username
      t.string :name
      t.string :avatar
      t.string :cover
      t.text :about_me
      t.text :about_library
      t.integer :account_type, :default => 0
      t.integer :privacy, :default => 0
      t.integer :language, :default => 0
      t.boolean :allow_comments, :default => true
      t.boolean :allow_friends, :default => true
      t.integer :email_privacy, :default => 0
      t.boolean :discoverable_by_email, :default => true
      t.boolean :receive_newsletters, :default => true
      t.references :user, index: true

      t.timestamps null: false
    end
    add_index :profiles, :username, unique: true
    add_foreign_key :profiles, :users
  end
end
