class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  before_action :set_enums, only: [:new, :edit]

  respond_to :html

  def index
    @books = policy_scope(Book).page(params[:page])
    respond_with(@books)
  end

  def show
    # Intantiate a new presenter.
    @book_presenter = BookPresenter.new(@book, view_context)
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

  private
    def set_book          
      @book = Book.find(params[:id])
      authorize @book
    end

    def book_params
      params.require(:book).permit(:title, :subtitle, :description, :image, :isbn, :isbn13, :ismn, :issn, :series, :pages, :publication_year, :publication_place, :price, :price_updated_at, :physical_description, :cover_type, :availability, :format, :original_language, :original_title, :publisher_id, :extra, :biblionet_id)
    end

    def set_enums
      @original_languages = Book.original_languages
      @availabilities     = Book.availabilities
      @cover_types        = Book.cover_types
      @formats            = Book.formats
    end
end
