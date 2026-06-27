# frozen_string_literal: true

class ViewTracker::AnalyticsAggregator
  SUPPORTED_INTERVALS = {
    hour: "hour",
    day: "day",
    week: "week",
    month: "month"
  }.freeze

  # Get popular resources in a time period
  def self.popular_resources(resource_class, duration: 1.month, limit: 10)
    Impression.where(impressionable_type: resource_class.name)
      .where("created_at > ?", duration.ago)
      .group(:impressionable_id)
      .order("count_id desc")
      .limit(limit)
      .count("id")
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
    period_sql = period_expression(interval)

    Impression.where(
      impressionable_type: resource.class.name,
      impressionable_id: resource.id
    ).where("created_at > ?", duration.ago)
     .group(Arel.sql(period_sql))
     .order(Arel.sql(period_sql))
     .count
  end

  def self.period_expression(interval)
    unit = SUPPORTED_INTERVALS.fetch(interval.to_sym) do
      raise ArgumentError, "Unsupported interval: #{interval}"
    end

    "date_trunc('#{unit}', impressions.created_at)"
  end
  private_class_method :period_expression
end
