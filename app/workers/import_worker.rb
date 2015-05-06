class ImportWorker
  include Sidekiq::Worker
  sidekiq_options queue: :maintenance, retry: false

  def perform(data_hash)   
    @data_hash = data_hash 
    import_all  
  end

  private

  def import_all(data_hash = @data_hash)
    import_authors    if data_hash.keys.include? 'author'
    import_publishers if data_hash.keys.include? 'publisher'
    import_books      if data_hash.keys.include? 'book'
    import_categories if data_hash.keys.include? 'category'
    # create_categories_from_json(data_hash)  
  end

  def import_authors(data_hash = @data_hash)
    data_hash['author'].each do |author|
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

  def import_publishers(data_hash = @data_hash)
    data_hash['publisher'].each do |publisher|
      publisher_record = Publisher.create(
        name:         publisher['name'], 
        owner:        publisher['owner'],
        biblionet_id: publisher['b_id']
      )

      publisher['bookstores'].each do |role, place| 
        publisher_record.places.create(
          name:      (publisher['name'] + ' - ' + role).to_s,
          role:       role,
          address:   (place['address'].kind_of?(Array) ? place['address'].join(', ') : place['address'] unless place['address'].nil?),
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

  def import_categories(data_hash = @data_hash)
    data_hash['category'].each do |category_tree|
      category_tree.each do |b_id, category|
        unless Category.exists?(name: category['name'], ddc: category['ddc']) or (b_id == "current")
          parent_id = category['parent'].nil? ? nil : Category.where(biblionet_id: category['parent']).first.id.to_i

          category_record = Category.create(
            name:         category['name'], 
            ddc:          category['ddc'],
            parent_id:    parent_id,
            biblionet_id: b_id
          )
        end
      end
    end    
  end

  def import_books(data_hash = @data_hash)
    data_hash['book'].each do |book|
      unless Book.exists?(biblionet_id: book['b_id'])
        publisher_biblionet_id = book['publisher']['b_id']      

        if Publisher.exists?(biblionet_id: publisher_biblionet_id)
          publisher_record = Publisher.find_by(biblionet_id: publisher_biblionet_id)
        else
          import_publishers_from_bookshark(publisher_biblionet_id) if book['publisher']['b_id'].present? 
          publisher_record = Publisher.find_by(biblionet_id: publisher_biblionet_id)
        end   

        publisher_id = publisher_record.id if publisher_record.present?    

        book_record = Book.create(
          title:                book['title'], 
          subtitle:             book['subtitle'],        
          image:                book['image'],

          isbn:                 book['isbn'],
          isbn13:               book['isbn_13'],
          ismn:                 book['ismn'],
          issn:                 book['issn'],
          series_name:          book['series']['name'],
          series_volume:        book['series']['volume'],
        
          publication_year:     book['publication']['year'],
          publication_version:  book['publication']['version'],
          publication_place:    book['publication']['place'],
          price:                book['price'],
          price_updated_at:     book['last_update'],

          size:                 book['physical_description']['size'],
          pages:                book['physical_description']['pages'],
          cover_type:          (book['physical_description']['cover_type'].present? ? Book.cover_types[book['physical_description']['cover_type']] : nil),
          availability:        (book['availability'].present? ? Book.availabilities[book['availability']] : nil),
          format:              (book['format'].present? ? Book.formats[book['format']] : nil),
          original_language:   (book['original_language'].present? ? Book.original_languages[book['original_language']] : nil),
          original_title:       book['original_title'],
          publisher_id:         publisher_id,
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
            if Category.exists?(biblionet_id: category['b_id'])
              category_record = Category.find_by(biblionet_id: category['b_id'])
            else
              import_categories_from_bookshark(category['b_id'])
              category_record = Category.find_by(biblionet_id: category['b_id'])
            end           
            
            book_record.categories << category_record
          end
        end

        if book['author'].present?
          book['author'].each do |author|
            if author['b_id']
              author_record = Author.find_by(biblionet_id: author['b_id'])
              book_record.contributions.create(job: 0, author: author_record)    
            else
              book_record.update(collective_work: true) if author == "Συλλογικό έργο"  
            end                 
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
  end  

  def import_publishers_from_bookshark(id)
    response = Bookshark::Extractor.new(format: 'json').publisher(id: id.to_i)
    import_publishers JSON.parse(response)
  end

  def import_categories_from_bookshark(id)
    response = Bookshark::Extractor.new(format: 'json').category(id: id.to_i)
    import_categories JSON.parse(response)
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