class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @categories = Category.roots
    respond_with(@categories)
  end

  def show
    @children = @category.children
    respond_with(@category, @children)
  end

  def new
    @category = Category.new
    @category.parent_id = params[:parent_id]
    
    respond_with(@category)
  end

  def edit
  end

  def create
    @category = Category.new(category_params)
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
    end

    def category_params
      params.require(:category).permit(:name, :ddc, :slug, :biblionet_id, :parent_id)
    end
end
