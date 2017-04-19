namespace :books do
  desc "Updates views count in all books"

  task update_views_count: :environment do
    puts 'Starting the views update...'

    Book.find_each{ |book| book.update_column(:views_count, book.impressionist_count) }

    puts 'Views update finished.'
  end
end
