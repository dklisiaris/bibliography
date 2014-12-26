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
    create_categories_from_json(@file_content)
    render :index                 
  end

  def import_from_url    
    require 'open-uri'
    @file_content = open(params[:url]).read
    create_categories_from_json(@file_content)

    render :index
  end

  def import_from_text
    @file_content = params[:content]
    create_categories_from_json(@file_content)

    render :index
  end  

  protected

  def create_categories_from_json(json_content)
    @imported_records = 0  
    categories_hash = JSON.parse(json_content)

    categories_copy = categories_hash.clone
    
    ActiveRecord::Base.transaction do
      categories_hash.each do |key, value|  
        create_category_and_anchestors!(key, value, categories_copy)         
      end
    end
   
    flash.now[:notice] = "Successfully imported #{@imported_records} records (categories)."

  end

  def create_category_and_anchestors!(key, value, categories_hash)
    unless Category.exists?(name: value['text'], ddc: value['ddc'])
      cat = Category.new
      if value['parent'].nil?
        cat.parent_id = nil
      else
        parent = Category.find_by(biblionet_id: value['parent'].to_i)
        cat.parent_id = parent.id unless parent.nil?
        if parent.nil?
          cat.parent_id = create_category_and_anchestors!(value['parent'], categories_hash[value['parent']], categories_hash) 
        end            
      end

      cat.name = value['text']   
      cat.ddc = value['ddc']
      cat.biblionet_id = key
      puts YAML::dump(cat) if cat.parent_id.nil?
      cat.save! 

      @imported_records += 1
      return cat.id
    end
  end

end
