# frozen_string_literal: true

class RecommendationService
  RESOURCE_TYPES = ['Book', 'Author', 'Category', 'Publisher', 'Shelf'].freeze

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
  # @param force_recalculate [Boolean] Force recalculation (skip cache)
  def self.similar_users(user, limit: 20, resource_type: 'Book', force_recalculate: false)
    new(user, resource_type, limit, force_recalculate).similar_users
  end

  # Update recommendations for a user (called after like/dislike)
  # @param user [User] The user whose recommendations need updating
  # @param resource_type [String, nil] Optional changed resource type to scope work
  def self.update_for(user, resource_type: nil)
    return unless user.present?

    resource_types = normalize_resource_types(resource_type)
    clear_for(user, resource_types: resource_types)
    UpdateRecommendationsJob.perform_later(user.id, resource_types: resource_types)
  end

  # Clear recommendation caches for a user without enqueueing a rebuild.
  def self.clear_for(user, resource_types: RESOURCE_TYPES)
    resource_types = normalize_resource_types(resource_types)
    CacheManager.clear_user(user, resource_types: resource_types)
    RedisStore.clear_user(user, resource_types: resource_types)
  end

  # Rebuild Redis for a user by recalculating from ratings table
  # Useful when Redis is cleared or needs to be restored
  def self.rebuild_redis_for(user)
    # Recalculate recommendations for all resource types
    RESOURCE_TYPES.each do |resource_type|
      recommendations_for(user, resource_type: resource_type, limit: 100, force_recalculate: true)
      similar_users(user, limit: 20, resource_type: resource_type, force_recalculate: true)
    end
  end

  def initialize(user, resource_type = 'Book', limit = 10, force_recalculate = false)
    @user = user
    @resource_type = resource_type
    @limit = limit
    @force_recalculate = force_recalculate
  end

  def recommendations
    return @resource_type.constantize.none unless @user.present?

    unless @force_recalculate
      # Try cache first (Rails cache - fastest)
      cached = RecommendationService::CacheManager.get_recommendations(@user, @resource_type, @limit)
      return cached if cached.present?

      # Get from Redis (fast)
      redis_recommendations = RecommendationService::RedisStore.get_recommendations(@user, @resource_type, @limit)
      return redis_recommendations if redis_recommendations.any?
    end

    # Calculate if not in Redis (can rebuild from ratings table)
    calculate_and_store_recommendations
  end

  def similar_users
    return User.none unless @user.present?

    unless @force_recalculate
      # Try cache first (Rails cache - fastest)
      cached = RecommendationService::CacheManager.get_similar_users(@user, @limit, resource_type: @resource_type)
      return cached if cached.present?

      # Get from Redis (fast)
      redis_similar = RecommendationService::RedisStore.get_similar_users(@user, @limit, resource_type: @resource_type)
      return redis_similar if redis_similar.any?
    end

    # Calculate if not in Redis (can rebuild from ratings table)
    calculate_and_store_similar_users
  end

  private

  def self.normalize_resource_types(resource_types)
    Array(resource_types.presence || RESOURCE_TYPES)
      .map(&:to_s)
      .select { |resource_type| RESOURCE_TYPES.include?(resource_type) }
      .presence || RESOURCE_TYPES
  end
  private_class_method :normalize_resource_types

  def calculate_and_store_recommendations
    # Find similar users (calculated from ratings table)
    neighbors = RecommendationService::NeighborFinder.find(@user, limit: 20, resource_type: @resource_type)

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
    RecommendationService::CacheManager.cache_recommendations(@user, @resource_type, recommendations, limit: @limit)

    recommendations
  end

  def calculate_and_store_similar_users
    # Find similar users (calculated from ratings table)
    # Use the resource_type from the instance (defaults to 'Book' for similar_users)
    similar_users = RecommendationService::NeighborFinder.find(@user, limit: @limit, resource_type: @resource_type)

    # Store in Redis (fast access) - Phase 1: Redis-only
    RecommendationService::RedisStore.store_similar_users(@user, similar_users, resource_type: @resource_type)

    # Cache in Rails cache (very fast)
    RecommendationService::CacheManager.cache_similar_users(@user, similar_users, @limit, resource_type: @resource_type)

    similar_users
  end
end

