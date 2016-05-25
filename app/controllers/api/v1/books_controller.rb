class Api::V1::BooksController < Api::V1::BaseController
  # before_filter :authenticate_user_from_token!

  def index
    books = policy_scope(Book).includes(:writers,:contributors,:publisher,:categories,:comment_threads)
    if custom_pagination?
      limit = params[:limit].try(:to_i)
      limit = (limit < 101) ? limit : 100

      offset = params[:offset].try(:to_i)

      books = books.limit(limit).offset(offset).order(id: :asc)
    else
      books = paginate(books)
    end
    # books = apply_filters(books, params.except(:limit, :offset))

    meta_attrs = meta_attributes(books) unless custom_pagination?

    render(
      json: books, 
      each_serializer: Api::V1::BookSerializer, 
      root: 'books', 
      meta: meta_attrs
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