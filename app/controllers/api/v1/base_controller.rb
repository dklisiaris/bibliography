class Api::V1::BaseController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :destroy_session

  rescue_from ActiveRecord::RecordNotFound, with: :not_found  

  skip_after_action :verify_authorized

  def destroy_session
    request.session_options[:skip] = true
  end
  
  def not_found
    return api_error(status: 404, errors: 'Not found')
  end  

  ##
  # Changes format of a Serializer object to json or pretty json
  #  
  # @param serializer The serializer object to change its format
  def apply_format(serializer)
    formatted = serializer.to_json
    formatted = JSON.pretty_generate(JSON.parse(formatted)) if params[:pretty].try(:to_i) == 1    
    return formatted    
  end

end