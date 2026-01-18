# frozen_string_literal: true

class CalculateSimilarityJob < ApplicationJob
  queue_as :recommendable

  # Retry a few times in case of temporary Redis issues
  retry_on Redis::BaseError, wait: :exponentially_longer, attempts: 3

  # Calculate similarity between two users
  # Useful for batch processing similarity calculations
  def perform(user1_id, user2_id, resource_type: 'Book')
    user1 = User.find_by(id: user1_id)
    user2 = User.find_by(id: user2_id)
    return unless user1.present? && user2.present?

    similarity = RecommendationService::SimilarityCalculator.jaccard_similarity(
      user1,
      user2,
      resource_type: resource_type
    )

    # Store in Redis for fast lookup
    RecommendationService::RedisStore.store_similarity(
      user1,
      user2,
      resource_type,
      similarity
    )

    Rails.logger.info "Calculated similarity #{similarity} between user #{user1_id} and #{user2_id} for #{resource_type}"
  end
end

