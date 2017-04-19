class PublishersController < ApplicationController
  before_action :set_publisher, only: [:show, :edit, :update, :destroy]
  before_action :set_rated_ids, only: [:show]
  before_action :set_owned_ids, only: [:show]

  respond_to :html

  impressionist :actions=>[:index]

  def index
    if params[:q].present?
      keyphrase = ApplicationController.helpers.latinize(params[:q])
      limit = params[:autocomplete].try(:to_i) == 1 ? 8 : 50
      # @publishers = policy_scope(Publisher)
      #   .search_by_name(keyphrase)
      #   .page(params[:page])
      #   .order(impressions_count: :desc)

      @publishers = policy_scope(Publisher)
        .search(keyphrase, body_options: {min_score: 0.1}, order: {_score: :desc},
          page: params[:page], per_page: limit)
    else
      @publishers = policy_scope(Publisher).page(params[:page]).order(impressions_count: :desc)
    end

    if params[:autocomplete].try(:to_i) == 1 and params[:q].present?
      render json: @publishers, each_serializer: Api::V1::Preview::PublisherSerializer, root: false
    else
      respond_with(@publishers)
    end
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
    if params[:q].present?
      respond_to do |format|

        format.html do
          @publishers = Publisher.search(params[:q],fields: [{'name' => :word_start}, 'owner'], page: params[:page], per_page: 25)
          render :index
        end

        format.json do
          @publishers = Publisher.search(params[:q],fields: [{'name' => :word_start}], limit: 10).map{|p| {name: p.name}}
          render json: @publishers, root: false
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
