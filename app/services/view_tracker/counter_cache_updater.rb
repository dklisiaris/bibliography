# frozen_string_literal: true

class ViewTracker::CounterCacheUpdater
  # Update the impressions_count counter cache for a resource
  def self.update(resource)
    new(resource).update
  end

  def initialize(resource)
    @resource = resource
  end

  def update
    return unless @resource.class.column_names.include?('impressions_count')

    # Impressions use has_many :impressions, as: :impressionable (polymorphic).
    # reset_counters only works with belongs_to counter_cache, so always count manually.
    manual_update
  end

  private

  def manual_update
    count = Impression.where(
      impressionable_type: @resource.class.name,
      impressionable_id: @resource.id
    ).count

    @resource.update_column(:impressions_count, count)
  end
end

