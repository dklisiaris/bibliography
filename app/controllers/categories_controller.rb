class CategoriesController < ApplicationController
  before_action :set_json_format, only: [:favourite]
  before_action :authenticate_user!, only: [:favourite]
  before_action :set_category, only: [:show, :edit, :update, :destroy, :favourite]
  skip_after_action :verify_policy_scoped, only: :index

  #Disable protection for stateless api json response
  protect_from_forgery with: :exception, except: [:favourite]

  respond_to :html

  def index
    @categories = Category.roots

    # TODO Replace this with favourite or featured categories
    if user_signed_in?
      @featured = current_user.liked_categories.limit(10)
    else
      @featured = Category.where(featured: true).limit(10)
    end    

    respond_with(@categories)
  end

  def show
    @children = @category.children
    @books = @category.books.page(params[:page])

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
    else
      current_user.unlike(@category)
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
end
