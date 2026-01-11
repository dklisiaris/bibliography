class BooksController < ApplicationController
  before_action :set_json_format, only: [:collections, :manage_collections, :like, :dislike]
  before_action :authenticate_user!, only: [:collections, :manage_collections, :like, :dislike]
  before_action :set_book
  skip_before_action :set_book, only: [:index, :new, :create, :my, :latest, :trending, :awarded, :featured]
  before_action :set_enums, only: [:new, :edit]
  before_action :set_shelves, only: [:index, :show, :my, :latest, :trending, :awarded, :featured]
  before_action :set_rated_ids, except: [:new, :edit, :create, :update, :destroy]
  before_action :set_owned_ids, except: [:new, :edit, :create, :update, :destroy]


  #Disable protection for stateless api json response
  protect_from_forgery with: :exception, except: [:manage_collections, :like, :dislike]

  respond_to :html

  def index
    is_autocomplete = (params[:autocomplete].try(:to_i) == 1)
    aggs = []
    aggs = {
      author: {limit: 50},
      publication_year: {limit: 20},
      publisher: {limit: 30},
      category: {limit: 30},
      series: {limit: 50},
      format: {limit: 10},
      language: {limit: 10},
      pages: {limit: 10}
    } unless is_autocomplete
    # limit = is_autocomplete ? 8 : 50
    limit = is_autocomplete ? 8 : 15

    @filters = {
      publication_year: params[:publication_year],
      author: params[:author],
      publisher: params[:publisher],
      category: params[:category],
      series: params[:series],
      format: params[:format],
      language: params[:language],
      pages: params[:pages]
    }.reject{ |k, v| v.blank? } unless is_autocomplete

    if params[:q].present?
      keyphrase = ApplicationController.helpers.latinize(params[:q])

      # @books = policy_scope(Book)
      #   .search_fast(keyphrase)
      #   .order(impressions_count: :desc)
      #   .limit(50)
      @books = policy_scope(Book)
        .search(keyphrase, where: @filters, aggs: aggs, includes: [:main_writer], body_options: {min_score: 0.1},
          order: {_score: :desc, views: :desc, has_image: :desc},
          page: params[:page], per_page: limit)
    else
      # @books = policy_scope(Book).page(params[:page]).order(impressions_count: :desc)
      @books = policy_scope(Book)
        .search("*", where: @filters, aggs: aggs, includes: [:main_writer], order: {_score: :desc, views: :desc, has_image: :desc},
          page: params[:page], per_page: limit)
    end
    # @books_est_count = 20 * @books.total_pages

    if params[:q].present? && (is_autocomplete || params[:loadmore].try(:to_i) == 1)
      render json: @books, each_serializer: Api::V1::Preview::BookSerializer, root: false
    else
      # Handle unknown formats gracefully
      respond_to do |format|
        format.html { render :index }
        format.json { render json: @books }
        format.any { render :index }  # Fallback for unknown formats
      end
    end
  end

  def featured
    authorize :book, :featured?
    @books = policy_scope(Book).includes(:main_writer).top(25)
    @top_authors = Author.includes(:masterpiece).top(5)
    @liked_author_ids = current_user.liked_author_ids if user_signed_in?
    respond_with(@books)
  end

  def trending
    authorize :book, :trending?

    # Get The 25 most viewed books this month (using impressions table)
    most_views_book_ids = Impression.where(impressionable_type: "Book")
      .where("created_at > ?", 1.month.ago)
      .where.not(impressionable_id: nil)
      .group(:impressionable_id)
      .order('count_id desc')
      .limit(25)
      .count('id')
      .keys

    most_views_author_ids = Impression.where(impressionable_type: "Author")
      .where("created_at > ?", 1.month.ago)
      .where.not(impressionable_id: nil)
      .group(:impressionable_id)
      .order('count_id desc')
      .limit(5)
      .count('id')
      .keys

    @books = policy_scope(Book).includes(:main_writer).where(id: most_views_book_ids)
    @trending_authors = Author.includes(:masterpiece).where(id: most_views_author_ids)
    @liked_author_ids = current_user.liked_author_ids if user_signed_in?

    respond_with(@books)
  end

  def awarded
    authorize :book, :awarded?
    @prizes = Prize.page(params[:page]).per(75).order(:name) unless params[:load_books] == "true"

    if(!(params[:load_awards] == "true"))
      if(params[:prize_id].present?)
        @books = Book.includes(:main_writer).joins(:awards).where("awards.prize_id = ?", params[:prize_id]).page(params[:page]).order("awards.year desc")
      else
        # most_awarded_book_ids = Award.where(awardable_type: "Book").page(params[:page])
        #   .group(:awardable_id).order('count_id desc').count('id').keys
        @books = policy_scope(Book).includes(:main_writer, awards: :prize).where.not(awards: { id: nil })
          .order("awards.year DESC NULLS LAST").page(params[:page])
      end
    end
  end

  def latest
    authorize :book, :latest?
    @books = policy_scope(Book).includes(:main_writer).where("created_at > ?", 1.month.ago).page(params[:page]).order(publication_year: :desc, created_at: :desc)

    unless params[:only_books] == "true"
      @latest_authors = Author.includes(:masterpiece).joins(:contributions).where(contributions: {job: 0}).order("contributions.created_at desc").limit(5)
      @liked_author_ids = current_user.liked_author_ids if user_signed_in?
    end
  end

  def show
    # Intantiate a new presenter.
    @book_presenter = BookPresenter.new(@book, view_context)
    @in_shelves = current_user.book_in_which_collections(@book) if user_signed_in?

    @bookshelves_count = Bookshelf.where(book_id: @book.id).count
    @views_count = @book.views_count || 0
    @viewers_count = @book.impressions_count

    @likes_count = @book.liked_by_count
    @dislikes_count = @book.disliked_by_count

    @comments = @book.root_comments.includes(:children, :user, children: {user: :profile})
      .order(created_at: :desc)

    # @book.increment!(:views_count)
    ViewTracker.track(@book, request: request, user: current_user)

    @categories = @book.categories

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
    filtered_params = book_params
    filtered_params["isbn"]   = nil if filtered_params["isbn"].blank?
    filtered_params["isbn13"] = nil if filtered_params["isbn13"].blank?
    filtered_params["ismn"]   = nil if filtered_params["ismn"].blank?
    @book.update(filtered_params)

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

    key = Shelf.find_by(built_in: true, id: params[:to_add]).try(:default_name).try(:to_sym)
    @book.create_activity key, owner: current_user if key.present?

    Bookshelf.remove_book_from_multiple_bookshelves(@book.id, params[:to_remove], current_user)

    shelf_names = current_user.shelves
      .where(built_in: true, id: params[:to_remove])
      .map{ |s| ("book." + s.default_name)}

    activities = current_user.activities.where(key: shelf_names, trackable: @book)
    activities.destroy_all

    render json: {status: 200, message: 'ok'}
  end

  def like
    authorize :book, :like?

    if !current_user.likes?(@book)
      if current_user.like(@book)
        @book.update_column(:liked_by_count_cache, @book.liked_by_count)
        @book.create_activity :recommend, owner: current_user
        BackupRatingsWorker.perform_async(current_user.id, @book.id, 'Book', 'like')
      end
    else
      if current_user.unlike(@book)
        @book.update_column(:liked_by_count_cache, @book.liked_by_count)
        activity = current_user.activities.find_by(key: "book.recommend", trackable: @book)
        activity.destroy if activity.present?
        BackupRatingsWorker.perform_async(current_user.id, @book.id, 'Book', 'unlike')
      end
    end

    render json: {status: 200, message: 'ok', likes: @book.liked_by_count, dislikes: @book.disliked_by_count}
  end

  def dislike
    authorize :book, :dislike?

    if not current_user.dislikes?(@book)
      current_user.dislike(@book)
      @book.update_column(:disliked_by_count_cache, @book.disliked_by_count)
      @book.create_activity :not_recommend, owner: current_user
      BackupRatingsWorker.perform_async(current_user.id, @book.id, 'Book', 'dislike')
    else
      current_user.undislike(@book)
      @book.update_column(:disliked_by_count_cache, @book.disliked_by_count)
      activity = current_user.activities.find_by(key: "book.not_recommend", trackable: @book)
      activity.destroy if activity.present?
      BackupRatingsWorker.perform_async(current_user.id, @book.id, 'Book', 'undislike')
    end

    render json: {status: 200, message: 'ok', likes: @book.liked_by_count, dislikes: @book.disliked_by_count}
  end

  def my
    authorize :book, :my?
    if params[:shelf]
      @shelf = current_user.shelves.find_by(id: params[:shelf])
      if @shelf.present?
        @books = @shelf.books.page(params[:page])
      else
        @books = current_user.books.page(params[:page])
      end
    else
      @books = current_user.books.page(params[:page])
    end

    respond_with(@books)
  end

  private
    def set_book
      @book = Book.includes(:authors, {awards: :prize}).find(params[:id])
      authorize @book
    end

    def set_shelves
      @shelves = current_user.shelves if user_signed_in?
    end

    def set_rated_ids
      if user_signed_in?
        @liked_book_ids = current_user.liked_book_ids
        @disliked_book_ids = current_user.disliked_book_ids
      end
    end

    def set_owned_ids
      @owned_book_ids = current_user.book_ids if user_signed_in?
    end

    def book_params
      params.require(:book).permit(:title, :subtitle, :description, :image,
        :isbn, :isbn13, :ismn, :issn, :series_name, :series_volume, :pages,
        :size, :cover_type, :publication_year, :publication_version,
        :publication_place, :price, :price_updated_at, :availability, :format,
        :language, :original_language, :original_title, :publisher_id, :extra,
        :biblionet_id, :slug, :remote_uploaded_cover_url)
    end

    def set_enums
      @availabilities     = Book.availabilities
      @cover_types        = Book.cover_types
      @formats            = Book.formats
    end

end
