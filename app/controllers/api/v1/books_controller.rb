class Api::V1::BooksController < Api::V1::BaseController
  before_filter :authenticate_user_from_token!

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

  def my
    books = current_user.books
    books = paginate(books)
    books = apply_filters(books, params)

    render(
      json: books, 
      each_serializer: Api::V1::BookSerializer, 
      root: 'books', 
      meta: meta_attributes(books)
    )
  end
end