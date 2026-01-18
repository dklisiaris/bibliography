# frozen_string_literal: true

require 'redis'

namespace :ratings do
  desc "Restore redis ratings from the db backup"

  task restore: :environment do
    puts 'Starting ratings restore...'

    Rating.all.each do |r|
      rater    = r.user
      rateable = r.rateable

      case r.rate
      when "like"
        rater.like(rateable)
      when "dislike"
        rater.dislike(rateable)
      when "hide"
        rater.hide(rateable)
      else
        puts "invalid rate"
      end

      if r.bookmark?
        rater.bookmark(rateable)
      end

    end

    puts 'Ratings restore completed.'
  end

  desc "Clear all old recommendable gem entries from Redis (use with caution!)"
  task clear_recommendable: :environment do
    print "Are you sure you want to clear ALL old recommendable gem entries from Redis? (yes/no): "
    confirmation = STDIN.gets.chomp
    
    unless confirmation.downcase == 'yes'
      puts "Aborted."
      exit 0
    end

    puts "Clearing old recommendable gem entries from Redis..."
    pattern = "recommendable:*"
    redis_url = ENV["REDIS_SERVER_URL"] || ENV["REDIS_CLIENT_URL"] || 'redis://127.0.0.1:6379/0'
    redis = Redis.new(url: redis_url)
    keys = redis.keys(pattern)
    
    if keys.empty?
      puts "No keys found matching pattern: #{pattern}"
    else
      puts "Found #{keys.size} keys to delete..."
      # Delete in batches to avoid memory issues with large key sets
      keys.each_slice(1000) do |batch|
        redis.del(*batch) if batch.any?
      end
      puts "Cleared #{keys.size} keys from Redis."
    end
    
    puts "Done!"
  end
end
