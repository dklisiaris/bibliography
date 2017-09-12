class AddMainWriterIdToBooks < ActiveRecord::Migration
  def change
    add_column :books, :main_writer_id, :integer
    add_index :books, :main_writer_id
  end
end
