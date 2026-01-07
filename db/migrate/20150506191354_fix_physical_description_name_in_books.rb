class FixPhysicalDescriptionNameInBooks < ActiveRecord::Migration[5.2]
  def change
    rename_column :books, :physical_description, :size
  end
end
