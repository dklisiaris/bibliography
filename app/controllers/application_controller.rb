class ApplicationController < ActionController::Base
  include Pundit

  # http_basic_authenticate_with name: ENV["SERVER_USERNAME"],
  #   password: ENV["SERVER_PASSWORD"], if: Proc.new{ Rails.env.production? }

  # Verify that controller actions are authorized. Optional, but good.
  after_action :verify_authorized,  except: :index, unless: :devise_controller?
  after_action :verify_policy_scoped, only: :index, unless: :devise_controller?
  before_action :prepare_meta_tags, if: -> { request.get? }

  # Prevent CSRF attacks by raising an exception.
  protect_from_forgery with: :exception

  after_action :expire_legacy_session_cookies, if: -> { Rails.env.production? || Rails.env.staging? }

  rescue_from ActionController::InvalidAuthenticityToken, with: :log_csrf_failure
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # rescue_from ActiveRecord::RecordNotFound, with: :not_found

  protected

  def not_found
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end

  def set_json_format
    request.format = :json
  end

  def prepare_meta_tags(options={})
    site_name   = "Bibliography GR"
    title       = I18n.t('metatags.title')
    description = I18n.t('metatags.description')
    keywords    = I18n.t('metatags.keywords')
    image       = options[:image] || "#{request.base_url}/logo.png"
    current_url = request.url

    # Let's prepare a nice set of defaults
    defaults = {
      site:        site_name,
      title:       title,
      image:       image,
      description: description,
      keywords:    keywords.split(" "),
      twitter: {
        title: title,
        site_name: site_name,
        site: '@bibliographygr',
        card: 'summary',
        description: description,
        image: image
      },
      og: {
        url: current_url,
        site_name: site_name,
        title: title,
        image: image,
        description: description,
        type: 'website'
      }
    }

    options.reverse_merge!(defaults)

    set_meta_tags options
  end

  private

  def expire_legacy_session_cookies
    LegacySessionCookies.expire!(cookies, host: request.host)
  end

  def log_csrf_failure(exception)
    cookie_header = request.headers["Cookie"].to_s
    unsigned = request.env["action_dispatch.request.unsigned_session_cookie"]
    unsigned_keys =
      case unsigned
      when Hash then unsigned.except("session_id").keys.join(",")
      else unsigned.inspect
      end

    Rails.logger.error(
      "[CSRF] path=#{request.path} host=#{request.host} ssl=#{request.ssl?} " \
      "legacy_cookies=#{cookie_header.scan(/#{LegacySessionCookies::LEGACY_KEY}=/).size} " \
      "v2_cookies=#{cookie_header.scan(/_bibliography_session_v2=/).size} " \
      "session_loaded=#{session.loaded?} session_keys=#{unsigned_keys.presence || 'empty'} " \
      "session_csrf=#{session[:_csrf_token].present?} param_token=#{params[:authenticity_token].present?}"
    )
    raise exception
  end

  def user_not_authorized(exception)
    policy_name = exception.policy.class.to_s.underscore

    if user_signed_in?
     flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
     redirect_to(request.referrer || root_path)
    else
      redirect_to(new_user_session_path)
    end
  end
end
