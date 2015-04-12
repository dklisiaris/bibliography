class AuthorsController < ApplicationController
  before_action :set_author, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @authors = policy_scope(Author).page(params[:page])
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

  private
    def set_author
      @author = Author.find(params[:id])
      authorize @author
    end

    def author_params
      params.require(:author).permit(:firstname, :lastname, :extra_info, :biography, :image, :biblionet_id)
    end
end
