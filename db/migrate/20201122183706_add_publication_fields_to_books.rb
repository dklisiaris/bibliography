class AddPublicationFieldsToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :first_publish_date, :date
    add_column :books, :current_publish_date, :date
    add_column :books, :future_publish_date, :date
  end
end
