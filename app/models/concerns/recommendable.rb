# frozen_string_literal: true

# Concern for models that can be recommended
# Replaces recommendable gem functionality
module Recommendable
  extend ActiveSupport::Concern

  included do
    # Models should already have: has_many :ratings, as: :rateable, dependent: :destroy
    # This concern just adds recommendation methods
  end

  class_methods do
    # Get recommended items for a user
    # @param user [User] The user to get recommendations for
    # @param limit [Integer] Number of recommendations to return
    # @return [ActiveRecord::Relation] Recommended items
    def recommended_for(user, limit: 10)
      RecommendationService.recommendations_for(
        user,
        resource_type: name,
        limit: limit
      )
    end

    # Get top-rated items (most liked)
    # @param count [Integer] Number of items to return
    # @return [ActiveRecord::Relation] Top-rated items
    def top(count: 10)
      like_rate = Rating.rates[:like]
      left_joins(:ratings)
        .where("ratings.id IS NULL OR ratings.rate = ?", like_rate)
        .group(:id)
        .order(Arel.sql("SUM(CASE WHEN ratings.rate = #{like_rate} THEN 1 ELSE 0 END) DESC"))
        .limit(count)
    end
  end

  # Instance methods
  # Get recommended items of this type for a user
  # @param user [User] The user to get recommendations for
  # @param limit [Integer] Number of recommendations to return
  # @return [ActiveRecord::Relation] Recommended items
  def recommended_for(user, limit: 10)
    self.class.recommended_for(user, limit: limit)
  end

  # Count of users who liked this item
  # @return [Integer] Number of likes
  def liked_by_count
    ratings.where(rate: :like).count
  end

  # Count of users who disliked this item
  # @return [Integer] Number of dislikes
  def disliked_by_count
    ratings.where(rate: :dislike).count
  end
end

