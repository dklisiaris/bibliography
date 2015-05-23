class NavigationCell < Cell::ViewModel  

  # Produces a content header just below top navigation bar 
  #
  # ==== Options
  #
  # * +:title+ - The title of header
  # * +:breadcrumbs+ - A hash of name-url values for each page in breadcrumbs. Last page is the current and must have a nil value.
  #
  # ==== Examples
  #   
  #   cell(:navigation).call(:content_header, title: 'Some title', breadcrumbs: { fa('home') => root_url, t('site_settings') => "#", 'Current Page' => nil })
  #
  def content_header(opts = {})      
    @title        = opts[:title]
    @content      = opts[:content]  
    @breadcrumbs  = opts[:breadcrumbs]      
    render
  end

  # Produces a breadcrumb of site pages/urls 
  #
  # ==== Options
  #
  # * +:breadcrumbs+ - A hash of name-url values for each page in breadcrumbs. Last page is the current and must have a nil value.
  #
  # ==== Examples
  #   
  #   cell(:navigation).call(:breadcrumb, breadcrumbs: {fa('home') => root_url, t('site_settings') => "#", t('import.import_label') => nil})
  #
  def breadcrumb(opts = {})
    unless opts[:breadcrumbs].nil? or opts[:breadcrumbs].empty?
      @breadcrumbs  = opts[:breadcrumbs]
      @current_page = @breadcrumbs.keys.last

      @breadcrumbs.delete(@breadcrumbs.keys.last)
    end
    render
  end

  # Produces a link button with tooltip
  #
  # ==== Options
  #
  # * +:name+     - The name it appears on button. It can be text or font-awesome icon.
  # * +:url+      - The target url.
  # * +:tooltip+  - The information that appears on hover as tooltip.
  # * +:style+    - The bootstrap style of the button i.e. default, primary, etc. (http://getbootstrap.com/css/#buttons).
  #
  # ==== Examples
  #   
  #   cell(:navigation).call(:btn_link_to, name: 'Home', url: root_url, tooltip: 'Go to home')
  #   cell(:navigation).call(:btn_link_to, name: fa('plus'), url: new_category_path, tooltip: t('categories.new'), style: 'success')
  #   cell(:navigation).call(:btn_link_to, name: fa('comment-o'), url: '/comments/new', tooltip: 'Leave a comment', style: 'danger')
  #
  def btn_link_to(opts = {})  
    name     = opts[:name]     ||= 'Page Name'
    url      = opts[:url]      ||= '#'
    tooltip  = opts[:tooltip]  ||= ''
    style    = opts[:style]    ||= 'primary'        
    
    link_to name, url, class: "btn btn-effect-ripple btn-#{style}", role: "button", :data => {"toggle" => "tooltip", "original-title" => tooltip}
  end

  private

  # Limits the max size of a string and adds ellipses in the end.
  # Used privately to limit the breadcrumbs size
  #
  # ==== Attributes
  #
  # * +:text+       - The text to be limited.
  # * +:max_length+ - Maximum permited characters.
  #  
  def ellipsize(text, max_length = 30)
    if text.length > max_length
      text = text[0..max_length].strip + '...'
    end
    text
  end

end
