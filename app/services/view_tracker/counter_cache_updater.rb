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

    # Check if this is a polymorphic association (can't use reset_counters)
    impressions_association = @resource.class.reflect_on_association(:impressions)
    
    if impressions_association&.polymorphic?
      # For polymorphic associations, use manual update
      manual_update
    else
      # For regular associations with counter_cache, use reset_counters
      begin
        @resource.class.reset_counters(@resource.id, :impressions)
      rescue StandardError => e
        Rails.logger.error "CounterCacheUpdater failed for #{@resource.class.name}##{@resource.id}: #{e.message}"
        # Fallback: Manual count update
        manual_update
      end
    end
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

