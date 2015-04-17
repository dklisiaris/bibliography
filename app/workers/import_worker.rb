class ImportWorker
  include Sidekiq::Worker
  sidekiq_options queue: :maintenance, retry: false

  def perform(data_hash)   
    @data_hash = data_hash 
    import_authors    if @data_hash.keys.include? 'author'
    import_publishers if @data_hash.keys.include? 'publisher'
    import_books      if @data_hash.keys.include? 'book'
    # create_categories_from_json(@data_hash)   
  end

  private

  def import_authors
    @data_hash['author'].each do |author|
      author_record = Author.create(
        firstname:    author['firstname'], 
        lastname:     author['lastname'],
        extra_info:   author['extra_info'],
        image:        author['image'],
        biography:    author['bio'],
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
        name:         publisher['name'], 
        owner:        publisher['owner'],
        biblionet_id: publisher['b_id']
      )

      publisher['bookstores'].each do |role, place| 
        publisher_record.places.create(
          name:      (publisher['name'] + ' - ' + role).to_s,
          role:       role,
          address:    place['address'].join(', '),
          telephone: (place['telephone'].kind_of?(Array) ? place['telephone'].join(', ') : place['telephone']),
          fax:        place['fax'],
          email:      place['email'],
          website:    place['website']
          # latitude: latitude,
          # longitude: longitude
        )                 
      end      
    end
  end  

  def import_books
    @data_hash['book'].each do |book|      
      book_record = Book.create(
        title:                book['title'], 
        subtitle:             book['subtitle'],        
        image:                book['image'],

        isbn:                 book['isbn'],
        isbn13:               book['isbn_13'],
        ismn:                 book['ismn'],
        issn:                 book['issn'],
        series:               book['series'],

        pages:                book['pages'],
        publication_year:     book['publication_year'],
        publication_place:    book['publication_place'],
        price:                book['price'],
        price_updated_at:     book['price_updated_at'],

        physical_description: book['physical_description'],
        cover_type:           book['cover_type'],
        availability:         book['availability'],
        format:               book['format'],
        original_language:    book['original_language'],
        original_title:       book['original_title'],
        publisher_id:         (Publisher.find_by(biblionet_id: book['publisher']['b_id'])).id,
        extra:                book['extra'],

        description:          book['description'],
        biblionet_id:         book['b_id']
      )

      if book['award'].present?
        book['award'].each do |award| 
          prize_record = Prize.find_or_create_by(name: award['name'])    
          book_record.awards.create(prize: prize_record, year: award['year'])              
        end
      end

      if book['category'].present?
        book['category'].each do |category| 
          book_record.categories << Category.find_by(biblionet_id: category['b_id'])
        end
      end

      if book['author'].present?
        book['author'].each do |author|
          author_record = Author.find_by(biblionet_id: author['b_id'])
          book_record.contributions.create(job: 0, author: author_record)           
        end
      end

      if book['contributors'].present?
        book['contributors'].each do |job, contributors|
          job_index = Contribution.jobs[job]
          contributors.each do |contributor|
            author_record = Author.find_by(biblionet_id: contributor['b_id'])
            book_record.contributions.create(job: job_index, author: author_record) 
          end
        end
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