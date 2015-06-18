class Api::V1::AuthorsController < Api::V1::BaseController
  def show
    author = Author.find(params[:id])
    impressionist(author)

    response = apply_format(Api::V1::AuthorSerializer.new(author))
    
    render(json: response)
  end
end