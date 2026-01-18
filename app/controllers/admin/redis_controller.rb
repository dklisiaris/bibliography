# frozen_string_literal: true

class Admin::RedisController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin
  skip_after_action :verify_authorized
  skip_after_action :verify_policy_scoped

  def index
    @pattern = params[:pattern].presence || '*'
    @namespace = params[:namespace].presence || ''
    @page = (params[:page].to_i > 0 ? params[:page].to_i : 1)
    @per_page = 50

    # Build search pattern
    search_pattern = @namespace.present? ? "#{@namespace}:#{@pattern}" : @pattern

    # Get keys (limited for performance)
    keys = redis.keys(search_pattern).sort
    @total_keys = keys.size
    @keys = keys[(@page - 1) * @per_page, @per_page] || []

    # Get key info
    @keys_info = @keys.map do |key|
      get_key_info(key)
    end
  end

  def show
    @key = params[:id]
    @key_info = get_key_info(@key)
    @value = get_key_value(@key, @key_info[:type])
  end

  def destroy
    @key = params[:id]
    redis.del(@key)
    redirect_to admin_redis_path, notice: "Key '#{@key}' deleted successfully"
  rescue => e
    redirect_to admin_redis_path, alert: "Error deleting key: #{e.message}"
  end

  def stats
    @info = redis.info
    @dbsize = redis.dbsize
    @keyspace = redis.info('keyspace')
  end

  private

  def require_admin
    redirect_to root_path, alert: 'Access denied' unless current_user&.role == 'admin'
  end

  def redis
    @redis ||= Redis.new(url: ENV['REDIS_SERVER_URL'] || ENV['REDIS_CLIENT_URL'] || 'redis://127.0.0.1:6379/0')
  end

  def get_key_info(key)
    type = redis.type(key)
    ttl = redis.ttl(key)
    size = get_key_size(key, type)

    {
      key: key,
      type: type,
      ttl: ttl > 0 ? ttl : (ttl == -1 ? 'no expiry' : 'expired'),
      size: size
    }
  end

  def get_key_size(key, type)
    case type
    when 'string'
      redis.strlen(key)
    when 'hash'
      redis.hlen(key)
    when 'list'
      redis.llen(key)
    when 'set'
      redis.scard(key)
    when 'zset'
      redis.zcard(key)
    else
      0
    end
  end

  def get_key_value(key, type)
    case type
    when 'string'
      value = redis.get(key)
      # Try to parse as JSON for better display
      begin
        JSON.parse(value)
      rescue
        value
      end
    when 'hash'
      redis.hgetall(key)
    when 'list'
      # Get first 100 items
      redis.lrange(key, 0, 99)
    when 'set'
      # Get all members (limited to 1000)
      redis.smembers(key).first(1000)
    when 'zset'
      # Get first 100 items with scores
      redis.zrange(key, 0, 99, with_scores: true)
    else
      'Unknown type'
    end
  end
end
