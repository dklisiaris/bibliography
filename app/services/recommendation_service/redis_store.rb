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

    # Return relation ordered by Redis ranking (preserve order using CASE)
    table_name = resource_type.constantize.table_name
    resource_type.constantize
      .where(id: item_ids)
      .order(Arel.sql("CASE #{table_name}.id " +
                      item_ids.each_with_index.map { |id, idx| "WHEN #{id} THEN #{idx}" }.join(' ') +
                      " END"))
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
  def self.get_similar_users(user, limit)
    key = similar_users_key(user)
    user_ids = redis.zrevrange(key, 0, limit - 1).map(&:to_i)
    return User.none if user_ids.empty?

    # Return relation ordered by similarity ranking (preserve order using CASE)
    User.where(id: user_ids)
        .order(Arel.sql("CASE users.id " +
                        user_ids.each_with_index.map { |id, idx| "WHEN #{id} THEN #{idx}" }.join(' ') +
                        " END"))
  end

  # Store similar users in Redis
  # Accepts either ActiveRecord::Relation or Array
  def self.store_similar_users(user, similar_users)
    key = similar_users_key(user)
    
    # Clear existing
    redis.del(key)

    # Convert to array if it's a relation
    users = similar_users.is_a?(Array) ? similar_users : similar_users.to_a

    # Store with similarity scores
    users.each_with_index do |similar_user, index|
      # Calculate similarity score (could be cached separately)
      similarity = RecommendationService::SimilarityCalculator.jaccard_similarity(user, similar_user)
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
  def self.clear_user(user)
    pattern = "#{REDIS_NAMESPACE}:user:#{user.id}:*"
    redis.keys(pattern).each { |key| redis.del(key) }
  end

  private

  def self.redis
    @redis ||= Redis.new(url: ENV["REDIS_SERVER_URL"])
  end

  def self.recommendations_key(user, resource_type)
    "#{REDIS_NAMESPACE}:user:#{user.id}:recommendations:#{resource_type.downcase}"
  end

  def self.similar_users_key(user)
    "#{REDIS_NAMESPACE}:user:#{user.id}:similar_users"
  end

  def self.similarity_key(user1, user2, resource_type)
    # Always use smaller ID first for consistency
    id1, id2 = [user1.id, user2.id].sort
    "#{REDIS_NAMESPACE}:similarity:#{id1}:#{id2}:#{resource_type.downcase}"
  end
end

