class BooksController < ApplicationController
  before_action :set_json_format, only: [:collections, :manage_collections, :like, :dislike]
  before_action :authenticate_user!, only: [:collections, :manage_collections, :like, :dislike]
  before_action :set_book
  skip_before_action :set_book, only: [:index, :new, :create, :my]
  before_action :set_enums, only: [:new, :edit]    
  
  #Disable protection for stateless api json response
  protect_from_forgery with: :exception, except: [:manage_collections, :like, :dislike]

  respond_to :html

  impressionist :actions=>[:index]

  def index
    if params[:q].present?           
      keyphrase = ApplicationController.helpers.latinize(params[:q])
      # @books = policy_scope(Book)        
      #   .search_fast(keyphrase)
      #   .order(impressions_count: :desc)
      #   .limit(50)

      @books = policy_scope(Book)        
        .search(keyphrase, order: {_score: :desc}, limit: 50)

    else
      @books = policy_scope(Book).page(params[:page]).order(impressions_count: :desc)
    end 
    # @books_est_count = 20 * @books.total_pages
    @shelves = current_user.shelves if user_signed_in?    

    if params[:autocomplete].try(:to_i) == 1 and params[:q].present?
      render json: @books, each_serializer: Api::V1::Preview::BookSerializer, root: false
    else
      respond_with(@books)
    end    
  end

  def show
    # Intantiate a new presenter.
    @book_presenter = BookPresenter.new(@book, view_context)
    @shelves = current_user.shelves if user_signed_in?
    @in_shelves = current_user.book_in_which_collections(@book) if user_signed_in?

    @bookshelves_count = Bookshelf.where(book_id: @book.id).count
    @views_count = @book.impressionist_count
    @viewers_count = @book.impressions_count

    @likes_count = @book.liked_by_count
    @dislikes_count = @book.disliked_by_count

    @comments = @book.comment_threads

    impressionist(@book)
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

    Bookshelf.add_book_to_multiple_bookshelves(@book.id, params[:to_add], current_user)

    Bookshelf.remove_book_from_multiple_bookshelves(@book.id, params[:to_remove], current_user)

    render json: {status: 200, message: 'ok'}
  end

  def like
    authorize :book, :like?

    if not current_user.likes?(@book)
      current_user.like(@book) 
    else
      current_user.unlike(@book)
    end

    render json: {status: 200, message: 'ok', likes: @book.liked_by_count, dislikes: @book.disliked_by_count}
  end

  def dislike
    authorize :book, :dislike?

    if not current_user.dislikes?(@book)
      current_user.dislike(@book) 
    else
      current_user.undislike(@book)
    end
    
    render json: {status: 200, message: 'ok', likes: @book.liked_by_count, dislikes: @book.disliked_by_count} 
  end  

  def my
    authorize :book, :my?

    @books = current_user.books.page(params[:page])
    @shelves = current_user.shelves if user_signed_in?
    
    respond_with(@books)
  end

  private
    def set_book          
      @book = Book.includes(:authors).find(params[:id])
      authorize @book
    end

    def book_params      
      params.require(:book).permit(:title, :subtitle, :description, :image, :isbn, :isbn13, :ismn, :issn, :series_name, :series_volume, :pages, :size, :cover_type, :publication_year, :publication_version, :publication_place, :price, :price_updated_at, :availability, :format, :language, :original_language, :original_title, :publisher_id, :extra, :biblionet_id, :slug)
    end

    def set_enums
      @availabilities     = Book.availabilities
      @cover_types        = Book.cover_types
      @formats            = Book.formats
    end

end
