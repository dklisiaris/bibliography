# frozen_string_literal: true

class ViewTracker::AnalyticsAggregator
  # Get popular resources in a time period
  def self.popular_resources(resource_class, duration: 1.month, limit: 10)
    Impression.where(impressionable_type: resource_class.name)
      .where("created_at > ?", duration.ago)
      .group(:impressionable_id)
      .order('count_id desc')
      .limit(limit)
      .count('id')
      .map { |id, count| [resource_class.find_by(id: id), count] }
      .compact
  end

  # Get unique visitors for a resource
  def self.unique_visitors(resource, duration: 1.month)
    Impression.where(
      impressionable_type: resource.class.name,
      impressionable_id: resource.id
    ).where("created_at > ?", duration.ago)
     .select(:ip_address, :user_id, :session_hash)
     .distinct
     .count
  end

  # Get views over time (for charts)
  def self.views_over_time(resource, duration: 1.month, interval: :day)
    Impression.where(
      impressionable_type: resource.class.name,
      impressionable_id: resource.id
    ).where("created_at > ?", duration.ago)
     .group_by_period(interval, :created_at)
     .count
  end
end

