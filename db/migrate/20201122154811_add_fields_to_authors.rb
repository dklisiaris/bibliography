class AddFieldsToAuthors < ActiveRecord::Migration[5.2]
  def change
    add_column :authors, :middle_name, :string
    add_column :authors, :born_year, :integer
    add_column :authors, :death_year, :integer
  end
end
