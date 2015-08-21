class Api::V1::BooksController < Api::V1::BaseController
  
  def index
    books = policy_scope(Book)
    books = paginate(books)
    books = apply_filters(books, params)

    render(
      json: books, 
      each_serializer: Api::V1::BookSerializer, 
      root: 'books', 
      meta: meta_attributes(books)
    )
  end

  def show
    book = Book.find(params[:id])
    impressionist(book)

    response = apply_format(Api::V1::BookSerializer.new(book))
    
    render(json: response)
  end
end