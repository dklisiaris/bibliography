# frozen_string_literal: true

class ViewTracker
  # Track a view for a resource
  # @param resource [ActiveRecord::Base] The model being viewed (Book, Author, etc.)
  # @param request [ActionDispatch::Request] The HTTP request object
  # @param user [User, nil] The current user (if logged in)
  # @param options [Hash] Additional options
  #   - async: Boolean (default: true) - Process in background job
  #   - force: Boolean (default: false) - Force tracking even if duplicate
  def self.track(resource, request:, user: nil, **options)
    new(resource, request, user, options).track
  end

  def initialize(resource, request, user, options = {})
    @resource = resource
    @request = request
    @user = user
    @options = { async: false, force: false }.merge(options)
  end

  def track
    # Always increment views_count (even on refresh)
    increment_views_count

    # Only create impression if not duplicate
    return unless should_track?

    if @options[:async]
      ViewTrackingJob.perform_later(
        impressionable_type: @resource.class.name,
        impressionable_id: @resource.id,
        user_id: @user&.id,
        ip_address: @request.remote_ip,
        session_hash: session_hash,
        request_hash: request_hash,
        controller_name: @request.params[:controller],
        action_name: @request.params[:action],
        referrer: @request.referer,
        params: @request.params.except(:controller, :action).to_json
      )
    else
      create_impression
    end
  end

  private

  def should_track?
    return true if @options[:force]
    return false unless @resource.present?

    # Check for duplicates
    !ViewTracker::DuplicateChecker.duplicate?(
      resource: @resource,
      ip: @request.remote_ip,
      session_hash: session_hash,
      user: @user
    )
  end

  def create_impression
    impression = Impression.create(
      impressionable_type: @resource.class.name,
      impressionable_id: @resource.id,
      user_id: @user&.id,
      ip_address: @request.remote_ip,
      session_hash: session_hash,
      request_hash: request_hash,
      controller_name: @request.params[:controller],
      action_name: @request.params[:action],
      referrer: @request.referer,
      params: @request.params.except(:controller, :action).to_json
    )

    # Update counter cache
    ViewTracker::CounterCacheUpdater.update(@resource) if impression.persisted?

    impression
  end

  def session_hash
    @request.session.id.to_s if @request.session.present?
  end

  def request_hash
    Digest::MD5.hexdigest([
      @request.remote_ip,
      @request.user_agent,
      @request.params.except(:controller, :action).to_json
    ].join)
  end

  def increment_views_count
    return unless @resource.present?
    return unless @resource.class.column_names.include?('views_count')

    # Use increment_counter for atomic update (doesn't trigger callbacks)
    @resource.class.increment_counter(:views_count, @resource.id)
  end
end