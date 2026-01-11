# frozen_string_literal: true

namespace :recommendations do
  desc "Rebuild Redis from ratings table for a specific user (Phase 1)"
  task :rebuild_redis_user, [:user_id] => :environment do |_t, args|
    user_id = args[:user_id] || ENV['USER_ID']
    
    if user_id.blank?
      puts "Usage: rake recommendations:rebuild_redis_user[USER_ID]"
      puts "   or: USER_ID=123 rake recommendations:rebuild_redis_user"
      exit 1
    end

    user = User.find_by(id: user_id)
    unless user
      puts "User with ID #{user_id} not found"
      exit 1
    end

    puts "Rebuilding Redis for user #{user.id} (#{user.email})..."
    puts "Recalculating from ratings table..."
    
    # Recalculate recommendations from ratings table
    ['Book', 'Author', 'Category', 'Publisher', 'Shelf'].each do |resource_type|
      recommendations = RecommendationService.recommendations_for(
        user,
        resource_type: resource_type,
        limit: 100,
        force_recalculate: true
      )
      puts "  #{resource_type}: #{recommendations.size} recommendations"
    end
    
    # Recalculate similar users
    similar_users = RecommendationService.similar_users(user, limit: 20)
    puts "  Similar users: #{similar_users.size}"
    
    puts "Done!"
  end

  desc "Rebuild Redis from ratings table for all users (Phase 1)"
  task rebuild_redis_all: :environment do
    puts "Rebuilding Redis for all users from ratings table..."
    puts "This may take a while..."
    
    count = 0
    User.find_each do |user|
      ['Book', 'Author', 'Category', 'Publisher', 'Shelf'].each do |resource_type|
        RecommendationService.recommendations_for(
          user,
          resource_type: resource_type,
          limit: 100,
          force_recalculate: true
        )
      end
      RecommendationService.similar_users(user, limit: 20)
      count += 1
      print "." if count % 10 == 0
    end
    
    puts "\nDone! Rebuilt Redis for #{count} users."
  end

  desc "Rebuild Redis from ratings table for users with ratings (Phase 1)"
  task rebuild_redis_with_ratings: :environment do
    puts "Rebuilding Redis for users who have ratings..."
    
    user_ids = Rating.distinct.pluck(:user_id)
    count = 0
    
    user_ids.each do |user_id|
      user = User.find_by(id: user_id)
      next unless user
      
      ['Book', 'Author', 'Category', 'Publisher', 'Shelf'].each do |resource_type|
        RecommendationService.recommendations_for(
          user,
          resource_type: resource_type,
          limit: 100,
          force_recalculate: true
        )
      end
      RecommendationService.similar_users(user, limit: 20)
      count += 1
      print "." if count % 10 == 0
    end
    
    puts "\nDone! Rebuilt Redis for #{count} users."
  end

  desc "Recalculate all recommendations (enqueue background jobs)"
  task recalculate: :environment do
    puts "Enqueuing recommendation update jobs for all users..."
    puts "This will process in the background via ActiveJob..."
    
    count = 0
    User.find_each do |user|
      UpdateRecommendationsJob.perform_later(user.id)
      count += 1
      print "." if count % 10 == 0
    end
    
    puts "\nDone! Enqueued #{count} jobs."
    puts "Jobs will be processed by your ActiveJob backend (Sidekiq, etc.)"
  end

  desc "Recalculate recommendations for users with ratings (enqueue background jobs)"
  task recalculate_with_ratings: :environment do
    puts "Enqueuing recommendation update jobs for users with ratings..."
    
    user_ids = Rating.distinct.pluck(:user_id)
    count = 0
    
    user_ids.each do |user_id|
      UpdateRecommendationsJob.perform_later(user_id)
      count += 1
      print "." if count % 10 == 0
    end
    
    puts "\nDone! Enqueued #{count} jobs."
    puts "Jobs will be processed by your ActiveJob backend (Sidekiq, etc.)"
  end

  desc "Clear all recommendations from Redis for a user"
  task :clear_user, [:user_id] => :environment do |_t, args|
    user_id = args[:user_id] || ENV['USER_ID']
    
    if user_id.blank?
      puts "Usage: rake recommendations:clear_user[USER_ID]"
      puts "   or: USER_ID=123 rake recommendations:clear_user"
      exit 1
    end

    user = User.find_by(id: user_id)
    unless user
      puts "User with ID #{user_id} not found"
      exit 1
    end

    puts "Clearing Redis recommendations for user #{user.id} (#{user.email})..."
    RecommendationService::RedisStore.clear_user(user)
    RecommendationService::CacheManager.clear_user(user)
    puts "Done!"
  end

  desc "Clear all recommendations from Redis (use with caution!)"
  task clear_all: :environment do
    print "Are you sure you want to clear ALL recommendations from Redis? (yes/no): "
    confirmation = STDIN.gets.chomp
    
    unless confirmation.downcase == 'yes'
      puts "Aborted."
      exit 0
    end

    puts "Clearing all recommendations from Redis..."
    pattern = "recommendations:*"
    redis = Redis.new(url: ENV["REDIS_SERVER_URL"])
    keys = redis.keys(pattern)
    
    if keys.empty?
      puts "No keys found matching pattern: #{pattern}"
    else
      redis.del(*keys) if keys.any?
      puts "Cleared #{keys.size} keys from Redis."
    end
    
    puts "Done!"
  end
end

