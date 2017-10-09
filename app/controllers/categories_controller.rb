class CategoriesController < ApplicationController
  before_action :set_json_format, only: [:favourite]
  before_action :authenticate_user!, only: [:favourite]
  before_action :set_category, only: [:show, :edit, :update, :destroy, :favourite]
  skip_after_action :verify_policy_scoped, only: :index
  before_action :set_rated_ids, only: [:show]
  before_action :set_owned_ids, only: [:show]

  #Disable protection for stateless api json response
  protect_from_forgery with: :exception, except: [:favourite]

  respond_to :html

  impressionist :actions=>[:index]

  def index
    @categories = Category.roots

    # TODO Replace this with favourite or featured categories
    if params[:q].present?
      keyphrase = ApplicationController.helpers.latinize(params[:q])
      # @featured = Category.search_by_name(keyphrase).limit(100)
      limit = params[:autocomplete].try(:to_i) == 1 ? 8 : 50

      @featured = Category.search(keyphrase, body_options: {min_score: 0.1},
        order: {_score: :desc}, page: params[:page], per_page: limit)
    elsif user_signed_in? && current_user.liked_categories_count > 0
      @featured = current_user.liked_categories.limit(10)
    else
      @featured = Category.where(featured: true).limit(10)
    end

    if params[:autocomplete].try(:to_i) == 1 and params[:q].present?
      render json: @featured, each_serializer: Api::V1::Preview::CategorySerializer, root: false
    else
      respond_with(@categories)
    end
  end

  def show
    @children = @category.children
    @books = @category.books.order(impressions_count: :desc, image: :asc).page(params[:page])
    impressionist(@category)

    respond_with(@category, @children)
  end

  def new
    @category = Category.new
    authorize @category
    @category.parent_id = params[:parent_id]

    respond_with(@category)
  end

  def edit
  end

  def create
    @category = Category.new(category_params)
    authorize @category
    @category.save

    respond_with(@category)
  end

  def update
    @category.update(category_params)
    respond_with(@category)
  end

  def destroy
    @category.destroy
    respond_with(@category)
  end

  def favourite
    authorize :category, :favourite?

    if not current_user.likes?(@category)
      current_user.like(@category)
      BackupRatingsWorker.perform_async(current_user.id, @category.id, 'Category', 'like')
    else
      current_user.unlike(@category)
      BackupRatingsWorker.perform_async(current_user.id, @category.id, 'Category', 'unlike')
    end

    render json: {status: 200, message: 'ok', favourite: current_user.likes?(@category)}
  end

  private
    def set_category
      @category = Category.find(params[:id])
      authorize @category
    end

    def category_params
      params.require(:category).permit(:name, :ddc, :slug, :biblionet_id, :parent_id, :featured)
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
