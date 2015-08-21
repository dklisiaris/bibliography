class Api::V1::BaseController < ApplicationController
  include ActiveHashRelation

  protect_from_forgery with: :null_session

  before_action :destroy_session

  rescue_from ActiveRecord::RecordNotFound, with: :not_found  

  skip_after_action :verify_authorized
  # skip_after_action :verify_policy_scoped

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

end