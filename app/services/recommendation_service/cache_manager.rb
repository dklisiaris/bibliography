# frozen_string_literal: true

class RecommendationService::CacheManager
  CACHE_TTL = 1.day

  # Get recommendations from Rails cache
  # Returns ActiveRecord::Relation or nil
  def self.get_recommendations(user, resource_type, limit)
    key = cache_key(user, "recommendations", resource_type, limit)
    cached_ids = Rails.cache.read(key)
    return nil unless cached_ids.present?
    
    # Reconstruct relation from cached IDs
    resource_type.constantize
      .then { |model| RecommendationService::OrderedRelation.where_id_in_order(model, cached_ids) }
  end

  # Cache recommendations (stores IDs for efficiency)
  # Accepts either ActiveRecord::Relation or Array
  def self.cache_recommendations(user, resource_type, recommendations)
    key = cache_key(user, "recommendations", resource_type, recommendations.size)
    # Store IDs instead of full objects for efficiency
    item_ids = recommendations.is_a?(Array) ? recommendations.map(&:id) : recommendations.pluck(:id)
    Rails.cache.write(key, item_ids, expires_in: CACHE_TTL)
  end

  # Get similar users from Rails cache
  # Returns ActiveRecord::Relation or nil
  def self.get_similar_users(user, limit)
    key = cache_key(user, "similar_users", nil, limit)
    cached_ids = Rails.cache.read(key)
    return nil unless cached_ids.present?
    
    # Reconstruct relation from cached IDs
    RecommendationService::OrderedRelation.where_id_in_order(User, cached_ids)
  end

  # Cache similar users (stores IDs for efficiency)
  # Accepts either ActiveRecord::Relation or Array
  def self.cache_similar_users(user, similar_users)
    key = cache_key(user, "similar_users", nil, similar_users.size)
    # Store IDs instead of full objects for efficiency
    user_ids = similar_users.is_a?(Array) ? similar_users.map(&:id) : similar_users.pluck(:id)
    Rails.cache.write(key, user_ids, expires_in: CACHE_TTL)
  end

  # Clear all cache for a user
  def self.clear_user(user)
    Rails.cache.delete_matched("recommendations/user:#{user.id}/*")
  end

  private

  def self.cache_key(user, type, resource_type, limit)
    parts = ["recommendations", "user:#{user.id}", type]
    parts << resource_type.downcase if resource_type
    parts << "limit:#{limit}"
    parts.join("/")
  end
end

