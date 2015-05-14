class BooksController < ApplicationController
  before_action :set_json_format, only: [:collections, :manage_collections]
  before_action :authenticate_user!, only: [:collections, :manage_collections]
  before_action :set_book, only: [:show, :edit, :update, :destroy, :collections, :manage_collections]
  before_action :set_enums, only: [:new, :edit]    
  
  #Disable protection for stateless api json responsed
  protect_from_forgery with: :exception, except: [:manage_collections]

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

  def manage_collections
    authorize :book, :manage_collections?

    to_add = params[:to_add].map(&:to_i) if params[:to_add].present?
    Bookshelf.add_book_to_multiple_bookshelves(@book.id, to_add)
    
    to_remove = params[:to_remove].map(&:to_i) if params[:to_remove].present?
    Bookshelf.remove_book_from_multiple_bookshelves(@book.id, to_remove)

    render json: {status: 200, message: 'ok'}
  end

  private
    def set_book          
      @book = Book.find(params[:id])
      authorize @book
    end

    def book_params      
      params.require(:book).permit(:title, :subtitle, :description, :image, :isbn, :isbn13, :ismn, :issn, :series_name, :series_volume, :pages, :size, :cover_type, :publication_year, :publication_version, :publication_place, :price, :price_updated_at, :availability, :format, :original_language, :original_title, :publisher_id, :extra, :biblionet_id)
    end

    def collection_params
      # params.require(:book).permit(:id, :format, :to_add, :to_remove)
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
