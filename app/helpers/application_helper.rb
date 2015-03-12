module ApplicationHelper

  def side_nav_li(text, path, icon=nil)
    content_tag(:li) do   
      options = current_page?(path) ? { class: "active" } : {}
      if icon
        link_to path, options do                           
          "<i class='#{icon} sidebar-nav-icon'></i><span class='sidebar-nav-mini-hide'>#{text}</span>".html_safe
        end 
      else
        link_to(text, path, options)
      end
    end
  end

  def top_nav_li(text, path, icon=nil)
    content_tag(:li) do 
      options = current_page?(path) ? { class: "active" } : {}
      link_to path, options do                           
        "<i class='#{icon}'></i><strong>#{text.upcase}</strong>".html_safe
      end     
    end
  end

  def top_nav_dropdown_li(text, path, icon=nil)
    content_tag(:li) do                                      
      link_to path do  
        content_tag(:i, nil, { class: "#{icon} fa-fw pull-right" }) + text                             
      end                                                            
    end
  end

  # Produces a font awesome icon html code i.e. <i class="fa fa-home"></i>
  # http://fortawesome.github.io/Font-Awesome/cheatsheet/
  #
  # ==== Examples
  #   
  #   fa 'home'
  #   fa('apple')
  #
  def fa(icon)
    content_tag(:i, nil, { class: "fa fa-#{icon}" })
  end

end
