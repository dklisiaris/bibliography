# frozen_string_literal: true

class ViewTracker::CounterCacheUpdater
  # Atomically bump impressions_count after a new impression is stored.
  def self.increment(resource, by: 1)
    new(resource).increment(by: by)
  end

  # Recalculate impressions_count from the impressions table (rake/reconcile).
  def self.update(resource)
    new(resource).update
  end

  def initialize(resource)
    @resource = resource
  end

  def increment(by: 1)
    return unless impressions_count_supported?

    @resource.class.increment_counter(:impressions_count, @resource.id, by: by)
  end

  def update
    return unless impressions_count_supported?

    manual_update
  end

  private

  def impressions_count_supported?
    @resource.class.column_names.include?("impressions_count")
  end

  def manual_update
    count = Impression.where(
      impressionable_type: @resource.class.name,
      impressionable_id: @resource.id
    ).count

    @resource.update_column(:impressions_count, count)
  end
end
