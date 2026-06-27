# frozen_string_literal: true

class RecommendationService::SimilarityCalculator
  # Calculate Jaccard similarity between two users
  # Jaccard = |A ∩ B| / |A ∪ B|
  # Where A = items liked by user1, B = items liked by user2
  def self.jaccard_similarity(user1, user2, resource_type: 'Book')
    new(user1, user2, resource_type).jaccard_similarity
  end

  # Jaccard similarity from preloaded like ID sets (avoids per-pair DB queries).
  def self.jaccard_similarity_from_sets(likes1, likes2)
    likes1 = Array(likes1)
    likes2 = Array(likes2)
    return 0.0 if likes1.empty? || likes2.empty?

    intersection = likes1 & likes2
    union = likes1 | likes2
    return 0.0 if union.empty?

    intersection.size.to_f / union.size
  end

  # Calculate similarity considering both likes and dislikes
  # Similarity = (likes_in_common - dislikes_in_common) / total_items
  def self.weighted_similarity(user1, user2, resource_type: 'Book')
    new(user1, user2, resource_type).weighted_similarity
  end

  def initialize(user1, user2, resource_type = 'Book')
    @user1 = user1
    @user2 = user2
    @resource_type = resource_type
  end

  def jaccard_similarity
    return 0.0 if @user1.id == @user2.id

    self.class.jaccard_similarity_from_sets(liked_items(@user1), liked_items(@user2))
  end

  def weighted_similarity
    return 0.0 if @user1.id == @user2.id

    user1_likes = liked_items(@user1)
    user1_dislikes = disliked_items(@user1)
    user2_likes = liked_items(@user2)
    user2_dislikes = disliked_items(@user2)

    # Items both users like
    likes_in_common = (user1_likes & user2_likes).size

    # Items both users dislike
    dislikes_in_common = (user1_dislikes & user2_dislikes).size

    # Items one likes and other dislikes (negative similarity)
    conflicts = (user1_likes & user2_dislikes).size + (user1_dislikes & user2_likes).size

    # Total items rated by both users
    total_items = (user1_likes | user1_dislikes | user2_likes | user2_dislikes).size

    return 0.0 if total_items.zero?

    # Weighted score: likes in common + dislikes in common - conflicts
    (likes_in_common + dislikes_in_common - conflicts).to_f / total_items
  end

  private

  def liked_items(user)
    # Uses existing ratings table with enum: rate: :like (0)
    Rating.where(
      user_id: user.id,
      rateable_type: @resource_type,
      rate: :like  # enum value: 0
    ).pluck(:rateable_id)
  end

  def disliked_items(user)
    # Uses existing ratings table with enum: rate: :dislike (1)
    Rating.where(
      user_id: user.id,
      rateable_type: @resource_type,
      rate: :dislike  # enum value: 1
    ).pluck(:rateable_id)
  end
end

