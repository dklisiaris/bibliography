# frozen_string_literal: true

class UpdateRecommendationsJob < ApplicationJob
  queue_as :recommendable

  # Retry a few times in case of temporary Redis issues
  retry_on Redis::BaseError, wait: :exponentially_longer, attempts: 3

  def perform(user_id, resource_types: ['Book', 'Author', 'Category', 'Publisher', 'Shelf'])
    user = User.find_by(id: user_id)
    return unless user.present?

    resource_types.each do |resource_type|
      # Calculate and store recommendations
      recommendations = RecommendationService.recommendations_for(
        user,
        resource_type: resource_type,
        limit: 100,
        force_recalculate: true
      )

      Rails.logger.info "Updated #{recommendations.size} recommendations for user #{user_id}, type: #{resource_type}"
    end

    # Also update similar users
    similar_users = RecommendationService.similar_users(user, limit: 20)
    Rails.logger.info "Updated #{similar_users.size} similar users for user #{user_id}"
  end
end

