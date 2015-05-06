class FixPhysicalDescriptionNameInBooks < ActiveRecord::Migration
  def change
    rename_column :books, :physical_description, :size
  end
end
