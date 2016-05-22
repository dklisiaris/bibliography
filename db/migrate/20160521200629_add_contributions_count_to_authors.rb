class AddContributionsCountToAuthors < ActiveRecord::Migration
  def change
    add_column :authors, :contributions_count, :integer, :default => 0

    Author.reset_column_information
    Author.find_each do |author|
      Author.reset_counters author.id, :contributions
    end
  end
end
