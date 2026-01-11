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
    cached = RecommendationService::RedisStore.get_similar_users(@user, @limit)
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
    neighbors = User.where(id: top_user_ids)
                    .order(Arel.sql("CASE users.id " +
                                    top_user_ids.each_with_index.map { |id, idx| "WHEN #{id} THEN #{idx}" }.join(' ') +
                                    " END"))

    # Store in Redis (need to convert to array for storage)
    RecommendationService::RedisStore.store_similar_users(@user, neighbors.to_a)

    neighbors
  end

  private

  def calculate_similarities
    # Get all users who have rated items of this type
    users_with_ratings = User.joins(:ratings)
      .where(ratings: { rateable_type: @resource_type })
      .where.not(id: @user.id)
      .distinct
      .pluck(:id)

    # Calculate similarity with each user
    similarities = {}
    users_with_ratings.each do |other_user_id|
      other_user = User.find_by(id: other_user_id)
      next unless other_user

      similarity = RecommendationService::SimilarityCalculator.jaccard_similarity(
        @user,
        other_user,
        resource_type: @resource_type
      )

      # Only store if similarity > 0
      similarities[other_user_id] = similarity if similarity > 0
    end

    similarities
  end
end

