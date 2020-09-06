class Api::V1::BaseController < ApplicationController
  include ActiveHashRelation

  protect_from_forgery with: :null_session

  before_action :destroy_session

  rescue_from ActiveRecord::RecordNotFound, with: :not_found!

  skip_after_action :verify_authorized
  # skip_after_action :verify_policy_scoped

  # before_action :authenticate_user_from_token!
  # skip_before_action  :verify_authenticity_token

  ##
  # Changes format of a Serializer object to json or pretty json
  #
  # @param serializer The serializer object to change its format
  def apply_format(serializer)
    formatted = serializer.to_json
    formatted = JSON.pretty_generate(JSON.parse(formatted)) if params[:pretty].try(:to_i) == 1
    return formatted
  end

  def paginate(resource)
    resource = resource.page(params[:page] || 1)
    if params[:per_page]
      resource = resource.per(params[:per_page])
    end

    return resource
  end

  #expects pagination!
  def meta_attributes(object)
    {
      current_page: object.current_page,
      next_page: object.next_page,
      prev_page: object.prev_page,
      total_pages: object.total_pages,
      total_count: object.total_count
    }
  end

  def custom_pagination?
    return (params[:limit].present? and params[:offset].present?) ? true : false
  end

  def authenticate_user_from_token!
      token, options = ActionController::HttpAuthentication::Token.token_and_options(request)
      # email = params[:email].presence
      # user  = email && User.find_by_email(email)

      user_email = options.blank?? nil : options[:email]
      user = user_email && User.find_by(email: user_email)

      # Notice how we use Devise.secure_compare to compare the token
      # in the database with the token given in the params, mitigating
      # timing attacks.
      if user && Devise.secure_compare(user.api_key, token)
        sign_in user, store: false
      else
        return unauthenticated!
      end
    end

    def destroy_session
      request.session_options[:skip] = true
    end

    def unauthenticated!
      response.headers['WWW-Authenticate'] = "Token realm=Application"
      render json: { error: 'Bad credentials', status: 401 }, status: 401
    end

    def unauthorized!
      render json: { error: 'not authorized', status: 403 }, status: 403
    end

    def invalid_resource!(errors = [])
      api_error(status: 422, errors: errors)
    end

    def not_found!
      render json: { error: 'Not found', status: 404 }, status: 404
    end

    def api_error(status: 500, errors: [])
      unless Rails.env.production? || Rails.env.staging?
        puts errors.full_messages if errors.respond_to? :full_messages
      end
      head status: status and return if errors.empty?

      render json: jsonapi_format(errors).to_json, status: status
    end

end
