namespace :books do
  desc "Invalidates cached books"

  task invalidate_cache: :environment do
    puts 'Invalidating books cache...'

    Rails.cache.delete("get_popular")
    Rails.cache.delete("get_popular_ids")
    Rails.cache.delete("get_latest")
    Rails.cache.delete("get_latest_ids")
    Rails.cache.delete("get_awarded")
    Rails.cache.delete("get_random_awarded")
    Rails.cache.delete("get_book_of_the_day_id")
    Rails.cache.delete("get_book_of_the_day")


    puts 'Books cache invalidated.'
  end
end
