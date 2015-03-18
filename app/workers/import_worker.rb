class ImportWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(json_content)
    create_categories_from_json(json_content)   
  end

  private

  def create_categories_from_json(json_content)    
    categories_hash = JSON.parse(json_content)

    categories_copy = categories_hash.clone    
    
    ActiveRecord::Base.transaction do
      categories_hash.each do |key, value|  
        create_category_and_anchestors!(key, value, categories_copy)         
      end
    end
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
      return cat.id
    end
  end
  

end