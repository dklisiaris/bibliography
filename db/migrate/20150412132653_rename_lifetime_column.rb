class RenameLifetimeColumn < ActiveRecord::Migration[5.2]
  def change
    rename_column :authors, :lifetime, :extra_info
  end
end
