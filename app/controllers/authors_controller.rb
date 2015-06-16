class AuthorsController < ApplicationController
  before_action :set_json_format, only: [:favourite]
  before_action :authenticate_user!, only: [:favourite]  
  before_action :set_author, only: [:show, :edit, :update, :destroy, :favourite]

  #Disable protection for stateless api json response
  protect_from_forgery with: :exception, except: [:favourite]

  respond_to :html

  impressionist :actions=>[:show,:index]

  def index
    if params[:q].present?           
      keyphrase = ApplicationController.helpers.latinize(params[:q])

      @authors = policy_scope(Author)        
        .search_by_name(keyphrase)
        .page(params[:page])
        .order(impressions_count: :desc, image: :asc)

    else
      @authors = policy_scope(Author).page(params[:page]).order(impressions_count: :desc, image: :asc)
    end    
    respond_with(@authors)
  end

  def show
    @awardable = @author
    @awards = @awardable.awards
    @award = Award.new

    respond_with(@author)
  end

  def new
    @author = Author.new
    authorize @author

    respond_with(@author)
  end

  def edit
  end

  def create
    @author = Author.new(author_params)
    authorize @author
    @author.save

    respond_with(@author)
  end

  def update
    @author.update(author_params)
    
    respond_with(@author)
  end

  def destroy
    @author.destroy

    respond_with(@author)
  end

  def favourite
    authorize :author, :favourite?

    if not current_user.likes?(@author)
      current_user.like(@author) 
    else
      current_user.unlike(@author)
    end

    render json: {status: 200, message: 'ok', favourite: current_user.likes?(@author)}
  end  

  private
    def set_author
      @author = Author.find(params[:id])
      authorize @author
    end

    def author_params
      params.require(:author).permit(:firstname, :lastname, :extra_info, :biography, :image, :biblionet_id)
    end
end
