class ImportController < ApplicationController 
  skip_after_action :verify_policy_scoped, only: :index 
  
  def index
    authorize :import, :index?    
  end

  def import_from_file
    authorize :import, :import_stuff?

    file_data = params[:uploaded_file]      
    if file_data.respond_to?(:read)
      file_content = file_data.read
    elsif file_data.respond_to?(:path)
      file_content = File.read(file_data.path)
    else
      # logger.error "Bad file_data: #{file_data.class.name}: #{file_data.inspect}"
      flash[:notice] = "Bad file_data: #{file_data.class.name}: #{file_data.inspect}" 
      redirect_to import_path
    end  

    content_hash = JSON.parse(file_content)
    ImportWorker.perform_async(content_hash)
    
    flash[:notice] = t('import.records_importing_in_bg')
    redirect_to import_path                
  end

  def import_from_url   
    authorize :import, :import_stuff? 
    require 'open-uri'

    file_content = open(params[:url]).read    

    content_hash = JSON.parse(file_content)
    ImportWorker.perform_async(content_hash)

    flash[:notice] = t('import.records_importing_in_bg')
    redirect_to import_path
  end

  def import_from_text
    authorize :import, :import_stuff?
    file_content = params[:content]    
    
    content_hash = JSON.parse(file_content)
    ImportWorker.perform_async(content_hash)

    flash[:notice] = t('import.records_importing_in_bg')
    redirect_to import_path
  end  

  def import_from_storage
    authorize :import, :import_stuff?

    StorageImportWorker.perform_async

    flash[:notice] = t('import.records_importing_in_bg')
    redirect_to import_path
  end

end
