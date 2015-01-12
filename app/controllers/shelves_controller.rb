class ShelvesController < ApplicationController
  before_action :set_shelf, only: [:show, :edit, :update, :destroy]
  before_action :set_enum, only: [:new, :edit]

  respond_to :html

  def index
    authorize :shelf, :index? unless user_signed_in?
    @shelves = policy_scope(Shelf) # current_user.shelves
    respond_with(@shelves)
  end

  def show
    respond_with(@shelf)
  end

  def new
    @shelf = current_user.shelves.new
    authorize @shelf
    respond_with(@shelf)
  end

  def edit
  end

  def create
    @shelf = current_user.shelves.new(shelf_params)
    authorize @shelf
    @shelf.save
    respond_with(@shelf)
  end

  def update
    @shelf.update(shelf_params)
    respond_with(@shelf)
  end

  def destroy
    @shelf.destroy
    respond_with(@shelf)
  end

  private
    def set_shelf
      @shelf = Shelf.find(params[:id])
      authorize @shelf
    end

    def set_enum      
      @privacies = Shelf.privacies
    end     

    def shelf_params
      params.require(:shelf).permit(:name, :privacy, :active)
    end
end
