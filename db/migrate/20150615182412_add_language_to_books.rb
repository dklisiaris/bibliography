class AddLanguageToBooks < ActiveRecord::Migration
  def change
    add_column :books, :language, :integer
  end
end
