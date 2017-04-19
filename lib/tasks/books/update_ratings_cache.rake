namespace :books do
  desc "Update cached like and dislike counters for all books"

  task update_ratings_cache: :environment do
    puts 'Starting the ratings cache update...'
    Book.all.each do |book|
      book.update_columns(liked_by_count_cache: book.liked_by_count, disliked_by_count_cache: book.disliked_by_count)
    end
    puts 'Book Ratings cache update finished.'
  end
end
