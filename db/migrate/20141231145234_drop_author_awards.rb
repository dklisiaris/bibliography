class DropAuthorAwards < ActiveRecord::Migration[5.2]
  def change
    drop_table :author_awards
  end
end
