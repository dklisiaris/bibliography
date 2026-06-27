class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update, :destroy]
  before_action :load_placeable
  skip_after_action :verify_policy_scoped, only: :index
  
  respond_to :html

  def index
    @places = @placeable.places
    respond_with(@places)
  end

  def show
    respond_with(@place)
  end

  def edit
    
  end

  def create
    @place = @placeable.places.new(place_attributes)
    authorize @place
    flash[:notice] = "Place created successfully!" if @place.save

    respond_with(@placeable)
  end

  def update
    flash[:notice] = "Place updated successfully!" if @place.update(place_attributes)
    respond_with(@placeable)
  end

  def destroy
    flash[:notice] = "Place deleted successfully!" if @place.destroy
    respond_with(@placeable)
  end

  private
    def set_place
      @place = Place.find(params[:id])
      authorize @place
    end

    def place_params
      params.require(:place).permit(:name, :address, :telephone, :fax, :email, :website, :latitude, :longitude)
    end

    # :role is Place venue type (e.g. headquarters), not User authorization — assigned outside permit.
    def place_attributes
      place_params.to_h.symbolize_keys.merge(role: params.dig(:place, :role).to_s.strip.presence)
    end

    def load_placeable
      resource, id = request.path.split('/')[1,2]
      @placeable = resource.singularize.classify.constantize.find(id)
    end
end
