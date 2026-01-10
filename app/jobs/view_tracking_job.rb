# frozen_string_literal: true

class ViewTrackingJob < ApplicationJob
  queue_as :default

  # # Don't retry - if it fails, it's not critical
  # discard_on StandardError do |job, error|
  #   Rails.logger.error "ViewTrackingJob failed: #{error.message}\n#{error.backtrace.first(5).join("\n")}"
  # end

  def perform(impressionable_type:, impressionable_id:, user_id: nil, ip_address: nil, 
              session_hash: nil, request_hash: nil, controller_name: nil, action_name: nil, 
              referrer: nil, params: nil)
    
    # Find the resource
    resource_class = impressionable_type.constantize
    resource = resource_class.find_by(id: impressionable_id)
    
    return unless resource.present?

    # Create impression
    impression = Impression.create(
      impressionable_type: impressionable_type,
      impressionable_id: impressionable_id,
      user_id: user_id,
      ip_address: ip_address,
      session_hash: session_hash,
      request_hash: request_hash,
      controller_name: controller_name,
      action_name: action_name,
      referrer: referrer,
      params: params
    )

    # Update counter cache if impression was created
    if impression.persisted?
      ViewTracker::CounterCacheUpdater.update(resource)
    end
  end
end