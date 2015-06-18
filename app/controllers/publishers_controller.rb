class PublishersController < ApplicationController
  before_action :set_publisher, only: [:show, :edit, :update, :destroy]

  respond_to :html

  impressionist :actions=>[:index]

  def index
    @publishers = policy_scope(Publisher).page(params[:page])    
    respond_with(@publishers)
  end

  def show
    @places = @publisher.places
    @books = @publisher.books.page(params[:page])
    @place = Place.new
    impressionist(@publisher)

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

  def search
    authorize :publisher, :search?
    if params[:query].present?
      respond_to do |format|

        format.html do
          @publishers = Publisher.search(params[:query],fields: [{'name' => :word_start}, 'owner'], page: params[:page], per_page: 25)                
          render :index          
        end

        format.json do
          @publishers = Publisher.search(params[:query],fields: [{'name' => :word_start}], limit: 10).map(&:name)
          render json: @publishers 
        end

      end  
    else
      redirect_to(publishers_url)
    end
  end  

  private
    def set_publisher
      @publisher = Publisher.find(params[:id])
      authorize @publisher
    end

    def publisher_params
      params.require(:publisher).permit(:name, :owner, :slug)
    end
end
