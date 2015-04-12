class RenameLifetimeColumn < ActiveRecord::Migration
  def change
    rename_column :authors, :lifetime, :extra_info
  end
end
