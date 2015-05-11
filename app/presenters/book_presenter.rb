class BookPresenter < BasePresenter
  presents :book

  def writers
    writers = book.writers        
    if writers.present?    
      html = writers.map do |writer|                  
        h.link_to(writer.fullname, writer)       
      end.join(', ').html_safe      
    end
    return html
  end

  def contributors
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
        html << UnicodeUtils.titlecase(job) + ': '
        html << contributors.map do |contributor|
          h.link_to(contributor.fullname, contributor)
        end.join(', ')
        html << h.tag(:br)
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

end