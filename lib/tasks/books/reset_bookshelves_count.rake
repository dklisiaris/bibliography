namespace :books do
  desc "Resets the bookshelves counter cache in all books"

  task reset_bookshelves_count: :environment do
    puts 'Starting the bookshelves counters reset...'

    Book.find_each{ |book| Book.reset_counters(book.id, :bookshelves) }

    puts 'Bookshelves count reset finished.'
  end
end
