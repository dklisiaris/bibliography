class ShelvesController < ApplicationController
  before_action :set_shelf, only: [:show, :edit, :update, :destroy]
  before_action :set_enum, only: [:new, :edit]

  respond_to :html

  def index
    authorize :shelf, :index? unless user_signed_in?
    @shelves = policy_scope(Shelf) # current_user.shelves
    respond_with(@shelves)
  end

  def public_shelves
    @profile = Profile.find(params[:id])
    @user = @profile.user

    if params[:shelf_id]
      @shelf = @user.shelves.find_by(id: params[:shelf_id])
      authorize @shelf
      if @shelf.present?
        @books = @shelf.books.page(params[:page])
      else
        @books = @user.books.page(params[:page])
      end
    else
      authorize @profile, :show?
      @books = @user.books.page(params[:page])
    end

    if @profile.is_public?
      @shelves = @user.shelves.where(privacy: [Shelf.privacies[:is_public], Shelf.privacies[:same_as_profile]])
    else
      @shelves = @user.shelves.is_public
    end

    respond_with(@books)
  end

  def show
    @books = @shelf.books.page(params[:page])
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
