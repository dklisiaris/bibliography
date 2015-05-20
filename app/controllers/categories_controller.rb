class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  skip_after_action :verify_policy_scoped, only: :index

  respond_to :html

  def index
    @categories = Category.roots

    # TODO Replace this with favourite or featured categories
    @books = Book.order(created_at: :desc).where.not(image: '').limit(10)

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

  private
    def set_category
      @category = Category.find(params[:id])
      authorize @category
    end

    def category_params
      params.require(:category).permit(:name, :ddc, :slug, :biblionet_id, :parent_id)
    end
end
