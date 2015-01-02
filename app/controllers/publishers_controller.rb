class PublishersController < ApplicationController
  before_action :set_publisher, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @publishers = policy_scope(Publisher).page(params[:page])
    respond_with(@publishers)
  end

  def show
    @placeable = @publisher
    @places = @placeable.places
    @place = Place.new
    respond_with(@publisher)
  end

  def new
    @publisher = Publisher.new
    authorize @publisher
    respond_with(@publisher)
  end

  def edit
  end

  def create
    @publisher = Publisher.new(publisher_params)
    authorize @publisher
    @publisher.save
    respond_with(@publisher)
  end

  def update
    @publisher.update(publisher_params)
    respond_with(@publisher)
  end

  def destroy
    @publisher.destroy
    respond_with(@publisher)
  end

  private
    def set_publisher
      @publisher = Publisher.find(params[:id])
      authorize @publisher
    end

    def publisher_params
      params.require(:publisher).permit(:name, :owner)
    end
end
