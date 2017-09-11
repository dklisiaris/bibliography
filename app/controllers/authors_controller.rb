class AuthorsController < ApplicationController
  before_action :set_json_format, only: [:favourite]
  before_action :authenticate_user!, only: [:favourite]
  before_action :set_author, only: [:show, :edit, :update, :destroy, :favourite]
  before_action :set_rated_ids, only: [:show]
  before_action :set_owned_ids, only: [:show]

  #Disable protection for stateless api json response
  protect_from_forgery with: :exception, except: [:favourite]

  respond_to :html

  impressionist :actions=>[:index]

  def index
    if params[:q].present?
      keyphrase = ApplicationController.helpers.latinize(params[:q])
      limit = params[:autocomplete].try(:to_i) == 1 ? 8 : 50
      # @authors = policy_scope(Author)
      #   .search_by_name(keyphrase)
      #   .page(params[:page])
      #   .order(impressions_count: :desc, image: :asc)

      @authors = policy_scope(Author)
        .search(keyphrase, body_options: {min_score: 0.1}, order: {_score: :desc},
          page: params[:page], per_page: limit)
    else
      @authors = policy_scope(Author).page(params[:page]).order(impressions_count: :desc, image: :asc)
    end
    @top_authors = Author.top(5)
    @recommended_authors = current_user.recommended_authors_cached if current_user.present?

    @liked_author_ids = current_user.liked_author_ids if current_user.present?

    if params[:autocomplete].try(:to_i) == 1 and params[:q].present?
      render json: @authors, each_serializer: Api::V1::Preview::AuthorSerializer, root: false
    else
      respond_with(@authors)
    end
  end

  def show
    @awardable = @author
    @awards = @awardable.awards
    @award = Award.new
    @liked = current_user.likes?(@author) if user_signed_in?
    @shelves = current_user.shelves if user_signed_in?
    impressionist(@author)

    @books = @author.books.order(impressions_count: :desc, id: :desc).page(params[:page])

    respond_with(@author)
  end

  def new
    @author = Author.new
    authorize @author

    respond_with(@author)
  end

  def edit
  end

  def create
    @author = Author.new(author_params)
    authorize @author
    @author.save

    respond_with(@author)
  end

  def update
    @author.update(author_params)

    respond_with(@author)
  end

  def destroy
    @author.destroy

    respond_with(@author)
  end

  def favourite
    authorize :author, :favourite?

    if not current_user.likes?(@author)
      current_user.like(@author)
    else
      current_user.unlike(@author)
    end

    render json: {status: 200, message: 'ok', favourite: current_user.likes?(@author)}
  end

  private
    def set_author
      @author = Author.includes({awards: :prize}).find(params[:id])
      authorize @author
    end

    def author_params
      params.require(:author).permit(:firstname, :lastname, :extra_info, :biography, :image, :biblionet_id, :remote_uploaded_avatar_url)
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
end
