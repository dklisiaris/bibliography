# frozen_string_literal: true

class RecommendationService::NeighborFinder
  # Find k-nearest neighbors (most similar users)
  def self.find(user, limit: 20, resource_type: 'Book')
    new(user, limit, resource_type).find
  end

  def initialize(user, limit = 20, resource_type = 'Book')
    @user = user
    @limit = limit
    @resource_type = resource_type
  end

  def find
    # Try Redis cache first
    cached = RecommendationService::RedisStore.get_similar_users(@user, @limit, resource_type: @resource_type)
    return cached if cached.any?

    # Calculate similarities
    similarities = calculate_similarities
    return User.none if similarities.empty?

    # Sort by similarity (descending) and get top user IDs
    top_user_ids = similarities
      .sort_by { |_user_id, similarity| -similarity }
      .first(@limit)
      .map { |user_id, _similarity| user_id }

    # Get relation ordered by similarity
    neighbors = RecommendationService::OrderedRelation.where_id_in_order(User, top_user_ids)

    # Store in Redis (need to convert to array for storage)
    RecommendationService::RedisStore.store_similar_users(@user, neighbors.to_a, resource_type: @resource_type)

    neighbors
  end

  private

  def calculate_similarities
    users_with_ratings = candidate_user_ids
    return {} if users_with_ratings.empty?

    other_users = User.where(id: users_with_ratings).index_by(&:id)
    likes_by_user_id = batch_liked_items([@user.id, *users_with_ratings])
    current_likes = likes_by_user_id[@user.id] || []
    return {} if current_likes.empty?

    similarities = {}
    other_users.each do |other_user_id, other_user|
      cached = RecommendationService::RedisStore.get_similarity(
        @user,
        other_user,
        @resource_type
      )

      similarity = if cached
                     cached
                   else
                     RecommendationService::SimilarityCalculator.jaccard_similarity_from_sets(
                       current_likes,
                       likes_by_user_id[other_user_id] || []
                     )
                   end

      next unless similarity > 0

      unless cached
        RecommendationService::RedisStore.store_similarity(
          @user, other_user, @resource_type, similarity
        )
      end

      similarities[other_user_id] = similarity
    end

    similarities
  end

  def candidate_user_ids
    User.joins(:ratings)
      .where(ratings: { rateable_type: @resource_type })
      .where.not(id: @user.id)
      .group('users.id')
      .having('COUNT(ratings.id) > ?', 5)
      .limit(1000)
      .pluck(:id)
  end

  def batch_liked_items(user_ids)
    Rating.where(
      user_id: user_ids,
      rateable_type: @resource_type,
      rate: :like
    ).pluck(:user_id, :rateable_id)
      .each_with_object({}) do |(user_id, rateable_id), likes_by_user|
        (likes_by_user[user_id] ||= []) << rateable_id
      end
  end
end

