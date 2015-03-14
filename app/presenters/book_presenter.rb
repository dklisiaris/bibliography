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
        html << job + ': '
        html << contributors.map do |contributor|
          h.link_to(contributor.fullname, contributor)
        end.join(', ')
        html << h.tag(:br)
      end
      return html.html_safe

    end
  end

end