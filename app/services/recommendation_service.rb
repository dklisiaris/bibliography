# frozen_string_literal: true

class RecommendationService
  # Get recommendations for a user
  # @param user [User] The user to get recommendations for
  # @param resource_type [String] Type of resource (Book, Author, Category, etc.)
  # @param limit [Integer] Number of recommendations to return
  # @param force_recalculate [Boolean] Force recalculation (skip cache)
  def self.recommendations_for(user, resource_type: 'Book', limit: 10, force_recalculate: false)
    new(user, resource_type, limit, force_recalculate).recommendations
  end

  # Find similar users for a user
  # @param user [User] The user to find similar users for
  # @param limit [Integer] Number of similar users to return
  # @param resource_type [String] Resource type to use for similarity calculation
  def self.similar_users(user, limit: 20, resource_type: 'Book')
    new(user, resource_type, limit, false).similar_users
  end

  # Update recommendations for a user (called after like/dislike)
  # @param user [User] The user whose recommendations need updating
  def self.update_for(user)
    UpdateRecommendationsJob.perform_later(user.id)
  end

  # Rebuild Redis for a user by recalculating from ratings table
  # Useful when Redis is cleared or needs to be restored
  def self.rebuild_redis_for(user)
    # Recalculate recommendations for all resource types
    ['Book', 'Author', 'Category', 'Publisher', 'Shelf'].each do |resource_type|
      recommendations_for(user, resource_type: resource_type, limit: 100, force_recalculate: true)
    end
    # Recalculate similar users
    similar_users(user, limit: 20)
  end

  def initialize(user, resource_type = 'Book', limit = 10, force_recalculate = false)
    @user = user
    @resource_type = resource_type
    @limit = limit
    @force_recalculate = force_recalculate
  end

  def recommendations
    return @resource_type.constantize.none unless @user.present?

    # Try cache first (Rails cache - fastest)
    unless @force_recalculate
      cached = RecommendationService::CacheManager.get_recommendations(@user, @resource_type, @limit)
      return cached if cached.present?
    end

    # Get from Redis (fast)
    redis_recommendations = RecommendationService::RedisStore.get_recommendations(@user, @resource_type, @limit)
    return redis_recommendations if redis_recommendations.any?

    # Calculate if not in Redis (can rebuild from ratings table)
    calculate_and_store_recommendations
  end

  def similar_users
    return User.none unless @user.present?

    # Try cache first (Rails cache - fastest)
    cached = RecommendationService::CacheManager.get_similar_users(@user, @limit)
    return cached if cached.present?

    # Get from Redis (fast)
    redis_similar = RecommendationService::RedisStore.get_similar_users(@user, @limit)
    return redis_similar if redis_similar.any?

    # Calculate if not in Redis (can rebuild from ratings table)
    calculate_and_store_similar_users
  end

  private

  def calculate_and_store_recommendations
    # Find similar users (calculated from ratings table)
    neighbors = RecommendationService::NeighborFinder.find(@user, limit: 20)

    # Generate recommendations
    recommendations = RecommendationService::RecommendationGenerator.generate(
      user: @user,
      resource_type: @resource_type,
      neighbors: neighbors,
      limit: @limit
    )

    # Store in Redis (fast access) - Phase 1: Redis-only
    RecommendationService::RedisStore.store_recommendations(@user, @resource_type, recommendations)

    # Cache in Rails cache (very fast)
    RecommendationService::CacheManager.cache_recommendations(@user, @resource_type, recommendations)

    recommendations
  end

  def calculate_and_store_similar_users
    # Find similar users (calculated from ratings table)
    # Use the resource_type from the instance (defaults to 'Book' for similar_users)
    similar_users = RecommendationService::NeighborFinder.find(@user, limit: @limit, resource_type: @resource_type)

    # Store in Redis (fast access) - Phase 1: Redis-only
    RecommendationService::RedisStore.store_similar_users(@user, similar_users)

    # Cache in Rails cache (very fast)
    RecommendationService::CacheManager.cache_similar_users(@user, similar_users)

    similar_users
  end
end

