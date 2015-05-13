class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy, :collections]
  before_action :set_enums, only: [:new, :edit]
  before_action :set_json_format, only: [:collections, :update_collections]

  respond_to :html

  def index
    @books = policy_scope(Book).page(params[:page])
    respond_with(@books)
  end

  def show
    # Intantiate a new presenter.
    @book_presenter = BookPresenter.new(@book, view_context)
    @shelves = current_user.book_in_which_collections(@book) if user_signed_in?
    respond_with(@book)
  end

  def new
    @book = Book.new
    authorize @book

    respond_with(@book)
  end

  def edit    
  end

  def create
    @book = Book.new(book_params)
    authorize @book
    @book.save

    respond_with(@book)
  end

  def update    
    @book.update(book_params)

    respond_with(@book)
  end

  def destroy    
    @book.destroy

    respond_with(@book)
  end

  # Shows a json respond with user collections this book belongs to  
  def collections    
    @shelves = current_user.book_in_which_collections(@book) if user_signed_in?  
  end

  def update_collections
    authorize :book, :update_collections?
    puts params[:to_add]
    puts params[:to_remove]

    render json: {status: 200, message: 'OK'}
  end

  private
    def set_book          
      @book = Book.find(params[:id])
      authorize @book
    end

    def book_params
      params.require(:book).permit(:title, :subtitle, :description, :image, :isbn, :isbn13, :ismn, :issn, :series_name, :series_volume, :pages, :size, :cover_type, :publication_year, :publication_version, :publication_place, :price, :price_updated_at, :availability, :format, :original_language, :original_title, :publisher_id, :extra, :biblionet_id)
    end

    def set_enums
      @original_languages = Book.original_languages
      @availabilities     = Book.availabilities
      @cover_types        = Book.cover_types
      @formats            = Book.formats
    end

    def set_json_format
      request.format = :json
    end
end
