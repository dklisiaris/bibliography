# frozen_string_literal: true

class RecommendationService::RecommendationGenerator
  # Generate recommendations based on similar users
  def self.generate(user:, resource_type:, neighbors:, limit: 10)
    new(user, resource_type, neighbors, limit).generate
  end

  def initialize(user, resource_type, neighbors, limit)
    @user = user
    @resource_type = resource_type
    @neighbors = neighbors
    @limit = limit
  end

  def generate
    # Get items liked by neighbors but not by current user
    recommended_items = find_recommended_items
    return @resource_type.constantize.none if recommended_items.empty?

    # Score items by how many neighbors liked them
    scored_items = score_items(recommended_items)
    return @resource_type.constantize.none if scored_items.empty?

    # Sort by score and get top item IDs
    top_item_ids = scored_items
      .sort_by { |_item_id, score| -score }
      .first(@limit)
      .map { |item_id, _score| item_id }

    # Return relation ordered by score (preserve order using CASE)
    table_name = @resource_type.constantize.table_name
    @resource_type.constantize
      .where(id: top_item_ids)
      .order(Arel.sql("CASE #{table_name}.id " +
                      top_item_ids.each_with_index.map { |id, idx| "WHEN #{id} THEN #{idx}" }.join(' ') +
                      " END"))
  end

  private

  def find_recommended_items
    # Items liked by neighbors
    # Handle both ActiveRecord::Relation and Array
    neighbor_ids = @neighbors.is_a?(Array) ? @neighbors.map(&:id) : @neighbors.pluck(:id)
    neighbor_liked_items = Rating.where(
      user_id: neighbor_ids,
      rateable_type: @resource_type,
      rate: :like
    ).pluck(:rateable_id).uniq

    # Items current user has already rated (liked or disliked)
    user_rated_items = Rating.where(
      user_id: @user.id,
      rateable_type: @resource_type
    ).pluck(:rateable_id)

    # Items to recommend = neighbor liked items - user rated items
    neighbor_liked_items - user_rated_items
  end

  def score_items(item_ids)
    return {} if item_ids.empty?

    # Count how many neighbors liked each item
    # Handle both ActiveRecord::Relation and Array
    neighbor_ids = @neighbors.is_a?(Array) ? @neighbors.map(&:id) : @neighbors.pluck(:id)
    scores = Rating.where(
      user_id: neighbor_ids,
      rateable_type: @resource_type,
      rate: :like,
      rateable_id: item_ids
    ).group(:rateable_id)
      .count

    # Weight by neighbor similarity (optional enhancement)
    weighted_scores = {}
    scores.each do |item_id, count|
      # Simple scoring: number of neighbors who liked it
      # Could be enhanced with similarity weights
      weighted_scores[item_id] = count
    end

    weighted_scores
  end
end

