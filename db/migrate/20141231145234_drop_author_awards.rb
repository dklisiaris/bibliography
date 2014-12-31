class DropAuthorAwards < ActiveRecord::Migration
  def change
    drop_table :author_awards
  end
end
