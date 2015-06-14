class BookPresenter < BasePresenter
  presents :book

  attr_reader :marc

  def initialize(object, template)
    super
    @marc = book.to_marc
  end  

  def writers
    writers = book.writers        
    if writers.present?    
      html = writers.map do |writer|                  
        h.link_to(writer.fullname, writer)       
      end.join(', ').html_safe      
    end
    return html
  end

  def contributors(isbd=false)
    contributions = book.contributions.contributors    
    if contributions.present? 
      current_job = ""     
      contributors_hash = {}
      contributors_array = []
           
      contributions.each do |contribution|  
        unless current_job == contribution.job
          contributors_array = []
          current_job = contribution.job
        end
        contributors_array << contribution.author
        contributors_hash[current_job] = contributors_array    
        # h.link_to contribution.author.fullname, contribution.author
      end  

      html = ""
      contributors_hash.each do |job, contributors|
        if isbd
          html << ', ' unless html.empty?
          html << UnicodeUtils.downcase(job) + ' '
          html << contributors.map do |contributor|
            contributor.fullname
          end.join(" [#{I18n.t('and')}] ")                    
        else
          html << UnicodeUtils.titlecase(job) + ': '
          html << contributors.map do |contributor|
            h.link_to(contributor.fullname, contributor)
          end.join(', ')
          html << h.tag(:br)
        end
      end
      return html.html_safe

    end
  end

  def publication
    html = []
    html << book.publication_place                                    if book.publication_place.present?
    html << h.link_to(book.publisher.name, book.publisher)            if book.publisher.present?
    html << book.publication_version.to_s + I18n.t('books.n_version') if book.publication_version.present?
    html << book.publication_year.to_s                                if book.publication_year.present?
    html.join(', ').html_safe
  end

  def genres
    html = []
    book.categories.each do |category|
      html << h.link_to(category.name, category)
    end
    html.join(h.tag(:br)).html_safe
  end

  def collections(shelves)
    html = []
    shelves.each do |shelf|
      html << h.link_to(shelf.screen_name, shelf)
    end
    html.join(h.tag(:br)).html_safe
  end  

  def physical_description
    html = []
    html << book.pages.to_s + I18n.t('books.pages') if book.pages
    html << book.cover_type.humanize if book.cover_type
    html << book.size + I18n.t('books.centimeters') if book.size
    html.join(', ').html_safe
  end

  def price
    html = []
    html << '€ ' + book.price.to_s
    html << "(#{I18n.t('books.last_updated')}: #{book.price_updated_at.to_s})"
    html << "[#{book.availability}]"
    html.join(', ').html_safe
  end  

  def trow(key,value)
    h.content_tag(:tr) do       
      h.content_tag(:td, h.content_tag(:strong, key)) +
      h.content_tag(:td, value)  
    end if value.present?    
  end

  def isbd_title
    writers = book.screen_writers    
    "#{book.title} / #{writers} ; #{contributors(true)}"
  end

  def isbd_main_author
    if book.collective_work?
      I18n.t('books.collective_work')
    else
      h.link_to(book.writers.first.fullname, book.writers.first) if book.writers.first.present? 
    end
  end

  def isdb_other_authors
    book.authors.map do |author|
      h.link_to author.fullname, author unless author.fullname == book.main_author
    end.reject(&:blank?).join(', ').html_safe
  end

  def marc_leader
    h.content_tag(:tr) do       
      h.content_tag(:td, h.content_tag(:strong, 'LEADER')) +
      h.content_tag(:td, @marc.leader, colspan: "2")  
    end   
  end

  def marc_control_fields
    html = []
    @marc.each do |control_field|
      html << h.content_tag(:tr) do       
        h.content_tag(:td, h.content_tag(:strong, control_field.tag)) +
        h.content_tag(:td, control_field.value, colspan: "2")
      end if control_field.is_a?(MARC::ControlField)       
    end
    html.join.html_safe
  end

  def marc_data_fields
    html = []
    @marc.each do |data_field|      
      html << h.content_tag(:tr) do              
        h.content_tag(:td, h.content_tag(:strong, data_field.tag)) +
        h.content_tag(:td, data_field.indicator1 + data_field.indicator2) +
        h.content_tag(:td) do
          subfields = []
          data_field.subfields.each do |subfield|
            subfields << h.content_tag(:strong, '|' + subfield.code) + ' ' + subfield.value if subfield.value.present?
          end
          subfields.join(' ').html_safe
        end 
      end if data_field.is_a?(MARC::DataField) and data_field.subfields.any?{|s| s.value.present?}
    end
    html.join.html_safe
  end

end