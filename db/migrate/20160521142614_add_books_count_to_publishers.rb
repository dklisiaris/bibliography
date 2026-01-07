class AddBooksCountToPublishers < ActiveRecord::Migration[5.2]
  def change
    add_column :publishers, :books_count, :integer, :default => 0

    Publisher.reset_column_information
    Publisher.all.each do |p|
      p.update_attribute :books_count, p.books.length
    end
  end
end
