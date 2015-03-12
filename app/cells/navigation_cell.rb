class NavigationCell < Cell::ViewModel  

  def content_header(opts = {})      
    @title        = opts[:title]  
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

end
