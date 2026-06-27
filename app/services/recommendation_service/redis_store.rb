# frozen_string_literal: true

require 'redis'

class RecommendationService::RedisStore
  REDIS_NAMESPACE = 'recommendations'
  RECOMMENDATIONS_TTL = 7.days.to_i
  SIMILAR_USERS_TTL = 7.days.to_i

  # Get recommendations from Redis
  # Returns ActiveRecord::Relation ordered by Redis score (recommendation ranking)
  def self.get_recommendations(user, resource_type, limit)
    key = recommendations_key(user, resource_type)
    item_ids = redis.zrevrange(key, 0, limit - 1).map(&:to_i)
    return resource_type.constantize.none if item_ids.empty?

    # Return relation ordered by Redis ranking (preserve order using in_order_of)
    RecommendationService::OrderedRelation.where_id_in_order(resource_type.constantize, item_ids)
  end

  # Store recommendations in Redis
  # Accepts either ActiveRecord::Relation or Array
  def self.store_recommendations(user, resource_type, recommendations)
    key = recommendations_key(user, resource_type)
    
    # Clear existing
    redis.del(key)

    # Convert to array if it's a relation
    items = recommendations.is_a?(Array) ? recommendations : recommendations.to_a
    
    # Store with scores (index in array = score, lower index = higher score)
    items.each_with_index do |item, index|
      redis.zadd(key, recommendations.size - index, item.id)
    end

    # Set expiration
    redis.expire(key, RECOMMENDATIONS_TTL)
  end

  # Get similar users from Redis
  # Returns ActiveRecord::Relation ordered by similarity score
  def self.get_similar_users(user, limit, resource_type: 'Book')
    key = similar_users_key(user, resource_type)
    user_ids = redis.zrevrange(key, 0, limit - 1).map(&:to_i)
    return User.none if user_ids.empty?

    # Return relation ordered by similarity ranking (preserve order using in_order_of)
    RecommendationService::OrderedRelation.where_id_in_order(User, user_ids)
  end

  # Store similar users in Redis
  # Accepts either ActiveRecord::Relation or Array
  def self.store_similar_users(user, similar_users, resource_type: 'Book')
    key = similar_users_key(user, resource_type)
    
    # Clear existing
    redis.del(key)

    # Convert to array if it's a relation
    users = similar_users.is_a?(Array) ? similar_users : similar_users.to_a

    # Store with similarity scores
    users.each_with_index do |similar_user, index|
      # Calculate similarity score (could be cached separately)
      similarity = RecommendationService::SimilarityCalculator.jaccard_similarity(
        user,
        similar_user,
        resource_type: resource_type
      )
      redis.zadd(key, similarity, similar_user.id)
    end

    # Set expiration
    redis.expire(key, SIMILAR_USERS_TTL)
  end

  # Store similarity score between two users
  def self.store_similarity(user1, user2, resource_type, similarity)
    key = similarity_key(user1, user2, resource_type)
    redis.setex(key, SIMILAR_USERS_TTL, similarity.to_s)
  end

  # Get similarity score between two users
  def self.get_similarity(user1, user2, resource_type)
    key = similarity_key(user1, user2, resource_type)
    redis.get(key)&.to_f
  end

  # Clear all recommendations for a user
  def self.clear_user(user, resource_types: RecommendationService::RESOURCE_TYPES)
    Array(resource_types).each do |resource_type|
      delete_keys(
        recommendations_key(user, resource_type),
        similar_users_key(user, resource_type),
        legacy_similar_users_key(user)
      )

      delete_matched("#{REDIS_NAMESPACE}:similarity:#{user.id}:*:#{resource_type.downcase}")
      delete_matched("#{REDIS_NAMESPACE}:similarity:*:#{user.id}:#{resource_type.downcase}")
    end
  end

  private

  def self.redis
    @redis ||= Redis.new(url: ENV["REDIS_SERVER_URL"] || ENV["REDIS_CLIENT_URL"] || 'redis://127.0.0.1:6379/0')
  end

  def self.recommendations_key(user, resource_type)
    "#{REDIS_NAMESPACE}:user:#{user.id}:recommendations:#{resource_type.downcase}"
  end

  def self.similar_users_key(user, resource_type)
    "#{REDIS_NAMESPACE}:user:#{user.id}:similar_users:#{resource_type.downcase}"
  end

  def self.legacy_similar_users_key(user)
    "#{REDIS_NAMESPACE}:user:#{user.id}:similar_users"
  end

  def self.similarity_key(user1, user2, resource_type)
    # Always use smaller ID first for consistency
    id1, id2 = [user1.id, user2.id].sort
    "#{REDIS_NAMESPACE}:similarity:#{id1}:#{id2}:#{resource_type.downcase}"
  end

  def self.delete_keys(*keys)
    keys.compact!
    redis.del(*keys) if keys.any?
  end

  def self.delete_matched(pattern)
    redis.scan_each(match: pattern) do |key|
      redis.del(key)
    end
  end
end

