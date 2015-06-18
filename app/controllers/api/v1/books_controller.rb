class Api::V1::BooksController < Api::V1::BaseController
  def show
    book = Book.find(params[:id])
    impressionist(book)

    response = apply_format(Api::V1::BookSerializer.new(book))
    
    render(json: response)
  end
end