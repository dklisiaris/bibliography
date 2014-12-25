class ImportController < ApplicationController
  def index
  end

  def import_from_file
    file_data = params[:uploaded_file]      
    if file_data.respond_to?(:read)
      @file_content = file_data.read
    elsif file_data.respond_to?(:path)
      @file_content = File.read(file_data.path)
    else
      # logger.error "Bad file_data: #{file_data.class.name}: #{file_data.inspect}"
      flash[:notice] = "Bad file_data: #{file_data.class.name}: #{file_data.inspect}" 
    end  
    render :imported_data                 
  end

  def import_from_url    
    require 'open-uri'
    @file_content = open(params[:url]).read

    render :imported_data
  end

  def import_from_text
    @file_content = params[:content]
    render :imported_data
  end  

end
