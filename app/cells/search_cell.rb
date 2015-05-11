class SearchCell < Cell::ViewModel
  def show
    render
  end

  def search_form(opts = {})
    @url         = opts[:url]
    @placeholder = opts[:placeholder]

    render
  end

end
