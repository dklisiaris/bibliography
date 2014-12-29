class AuthorAwardsController < ApplicationController
  before_action :set_author_award, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @author_awards = AuthorAward.all.page(params[:page])
    respond_with(@author_awards)
  end

  def show
    respond_with(@author_award)
  end

  # def new
  #   @author_award = AuthorAward.new
  #   respond_with(@author_award)
  # end

  def edit
    @author = @author_award.author    
  end

  def create
    @author_award = AuthorAward.new(author_award_params)
    flash[:notice] = "Award created successfully." if @author_award.save
    respond_with(@author_award.author)
  end

  def update
    if @author_award.update(author_award_params)
      flash[:notice] = "Award updated successfully."
    end
    respond_with(@author_award.author)
  end

  def destroy    
    author = @author_award.author
    flash[:notice] = "Award deleted successfully." if @author_award.destroy
    respond_with(author)
  end

  private
    def set_author_award
      @author_award = AuthorAward.find(params[:id])
    end

    def author_award_params
      params.require(:author_award).permit(:author_id, :prize_id, :year)
    end
end
