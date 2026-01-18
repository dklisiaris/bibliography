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

    # Check if this is a polymorphic association
    impressions_association = @resource.class.reflect_on_association(:impressions)
    
    # For polymorphic associations, reset_counters doesn't work properly
    # because it expects a belongs_to with counter_cache, not a has_many
    # Always use manual update for polymorphic associations
    if impressions_association&.polymorphic?
      manual_update
    else
      # For non-polymorphic associations, try reset_counters
      # But wrap in rescue since it may still fail if counter_cache isn't properly configured
      begin
        @resource.class.reset_counters(@resource.id, :impressions)
      rescue NoMethodError, ArgumentError => e
        # reset_counters failed (likely no counter_cache configured)
        # Fallback to manual update
        Rails.logger.debug "CounterCacheUpdater: reset_counters failed for #{@resource.class.name}##{@resource.id}, using manual update: #{e.message}"
        manual_update
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

