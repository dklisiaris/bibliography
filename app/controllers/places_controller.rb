class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update, :destroy]
  before_action :load_placeable
  
  respond_to :html

  def index
    @places = @placeable.places
    respond_with(@places)
  end

  def show
    respond_with(@place)
  end

  def new
    @place = @placeable.places.new
    respond_with(@place)
  end

  def edit
    
  end

  def create
    @place = @placeable.places.new(place_params)
    flash[:notice] = "Place created successfully!" if @place.save

    respond_with(@placeable)
  end

  def update
    flash[:notice] = "Place updated successfully!" if @place.update(place_params)
    respond_with(@placeable)
  end

  def destroy
    flash[:notice] = "Place deleted successfully!" if @place.destroy
    respond_with(@placeable)
  end

  private
    def set_place
      @place = Place.find(params[:id])
    end

    def place_params
      params.require(:place).permit(:name, :role, :address, :telephone, :fax, :email, :website, :latitude, :longitude, :placeable_id, :placeable_type)
    end

    def load_placeable
      resource, id = request.path.split('/')[1,2]
      @placeable = resource.singularize.classify.constantize.find(id)
    end
end
