class Api::V1::AuthorsController < Api::V1::BaseController
  def index
    authors = policy_scope(Author)
    authors = paginate(authors)
    authors = apply_filters(authors, params)

    render(
      json: authors, 
      each_serializer: Api::V1::AuthorSerializer, 
      root: 'authors', 
      meta: meta_attributes(authors)
    )
  end

  def show
    author = Author.find(params[:id])
    impressionist(author)

    response = apply_format(Api::V1::AuthorSerializer.new(author))
    
    render(json: response)
  end
end