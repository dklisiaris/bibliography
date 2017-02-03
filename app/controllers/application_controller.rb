class ApplicationController < ActionController::Base
  include Pundit

  # Verify that controller actions are authorized. Optional, but good.
  after_action :verify_authorized,  except: :index, unless: :devise_controller?
  after_action :verify_policy_scoped, only: :index, unless: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # rescue_from ActiveRecord::RecordNotFound, with: :not_found

  protected

  def not_found
    render file: "#{Rails.root}/public/404.html", layout: false, status: 404
  end

  def set_json_format
    request.format = :json
  end

  private

  def user_not_authorized(exception)
   policy_name = exception.policy.class.to_s.underscore

   flash[:error] = t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
   redirect_to(request.referrer || root_path)
  end
end
