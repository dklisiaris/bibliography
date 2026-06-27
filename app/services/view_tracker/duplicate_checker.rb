# frozen_string_literal: true

class ViewTracker::DuplicateChecker
  USER_WINDOW = 1.hour
  SESSION_WINDOW = 1.hour
  IP_WINDOW = 5.minutes

  # Check if this view is a duplicate
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
    return false unless @resource.present?

    matchers = []
    binds = []

    if @user.present?
      matchers << "(user_id = ? AND created_at > ?)"
      binds.push(@user.id, USER_WINDOW.ago)
    end

    if @session_hash.present?
      matchers << "(session_hash = ? AND created_at > ?)"
      binds.push(@session_hash, SESSION_WINDOW.ago)
    end

    if @ip.present?
      matchers << "(ip_address = ? AND created_at > ?)"
      binds.push(@ip, IP_WINDOW.ago)
    end

    return false if matchers.empty?

    Impression.where(
      impressionable_type: @resource.class.name,
      impressionable_id: @resource.id
    ).where([matchers.join(" OR "), *binds]).exists?
  end
end
