# frozen_string_literal: true

class ViewTracker::DuplicateChecker
  # Check if this view is a duplicate
  # Uses Redis for fast lookups (optional, can use DB)
  def self.duplicate?(resource:, ip:, session_hash:, user:)
    new(resource, ip, session_hash, user).duplicate?
  end

  def initialize(resource, ip, session_hash, user)
    @resource = resource
    @ip = ip
    @session_hash = session_hash
    @user = user
  end

  def duplicate?
    # Strategy 1: Check by user (if logged in)
    return true if user_duplicate?

    # Strategy 2: Check by session (within 1 hour)
    return true if session_duplicate?

    # Strategy 3: Check by IP (within 5 minutes)
    return true if ip_duplicate?

    false
  end

  private

  def user_duplicate?
    return false unless @user.present?

    # Check if user viewed this resource in last hour
    Impression.where(
      impressionable_type: @resource.class.name,
      impressionable_id: @resource.id,
      user_id: @user.id
    ).where("created_at > ?", 1.hour.ago).exists?
  end

  def session_duplicate?
    return false unless @session_hash.present?

    # Check if session viewed this resource in last hour
    Impression.where(
      impressionable_type: @resource.class.name,
      impressionable_id: @resource.id,
      session_hash: @session_hash
    ).where("created_at > ?", 1.hour.ago).exists?
  end

  def ip_duplicate?
    return false unless @ip.present?

    # Check if IP viewed this resource in last 5 minutes
    Impression.where(
      impressionable_type: @resource.class.name,
      impressionable_id: @resource.id,
      ip_address: @ip
    ).where("created_at > ?", 5.minutes.ago).exists?
  end
end

