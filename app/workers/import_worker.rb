class ImportWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(data_hash)   
    @data_hash = data_hash 
    import_authors if @data_hash.keys.include? 'author'
    import_publishers if @data_hash.keys.include? 'publisher'
    # create_categories_from_json(@data_hash)   
  end

  private

  def import_authors
    @data_hash['author'].each do |author|
      author_record = Author.create(
        firstname: author['firstname'], 
        lastname: author['lastname'],
        extra_info: author['lifetime'],
        image: author['image'],
        biography: author['bio'],
        biblionet_id: author['b_id']
      )

      if author['award'].present?
        author['award'].each do |award| 
          prize_record = Prize.find_or_create_by(name: award['name'])    
          author_record.awards.create(prize: prize_record, year: award['year'])              
        end
      end

    end
  end    

  def import_publishers
    @data_hash['publisher'].each do |publisher|
      publisher_record = Publisher.create(
        name: publisher['name'], 
        owner: publisher['owner'],
        biblionet_id: publisher['b_id']
      )

      publisher['bookstores'].each do |role, place| 
        publisher_record.places.create(
          name: (publisher['name'] + ' - ' + role).to_s,
          role: role,
          address: place['address'].join(', '),
          telephone: (place['telephone'].kind_of?(Array) ? place['telephone'].join(', ') : place['telephone']),
          fax: place['fax'],
          email: place['email'],
          website: place['website']
          # latitude: latitude,
          # longitude: longitude
        )                 
      end      
    end
  end  


  # Obsolete methods in our new API
  # def create_categories_from_json(data_hash)        
  #   categories_hash = data_hash
  #   categories_copy = categories_hash.clone    
    
  #   ActiveRecord::Base.transaction do
  #     categories_hash.each do |key, value|  
  #       create_category_and_anchestors!(key, value, categories_copy)         
  #     end
  #   end
  # end

  # def create_category_and_anchestors!(key, value, categories_hash)    
  #   unless Category.exists?(name: value['text'], ddc: value['ddc'])
  #     cat = Category.new
  #     if value['parent'].nil?
  #       cat.parent_id = nil
  #     else
  #       parent = Category.find_by(biblionet_id: value['parent'].to_i)
  #       cat.parent_id = parent.id unless parent.nil?
  #       if parent.nil?
  #         cat.parent_id = create_category_and_anchestors!(value['parent'], categories_hash[value['parent']], categories_hash) 
  #       end            
  #     end

  #     cat.name = value['text']   
  #     cat.ddc = value['ddc']
  #     cat.biblionet_id = key
  #     # puts YAML::dump(cat) if cat.parent_id.nil?      
  #     cat.save!
  #     return cat.id
  #   end
  # end
  

end