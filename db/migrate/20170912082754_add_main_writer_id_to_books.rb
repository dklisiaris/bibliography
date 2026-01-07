class AddMainWriterIdToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :main_writer_id, :integer
    add_index :books, :main_writer_id
  end
end
