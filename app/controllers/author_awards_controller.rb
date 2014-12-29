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

  def new
    @author_award = AuthorAward.new
    respond_with(@author_award)
  end

  def edit
  end

  def create
    @author_award = AuthorAward.new(author_award_params)
    @author_award.save
    respond_with(@author_award)
  end

  def update
    @author_award.update(author_award_params)
    respond_with(@author_award)
  end

  def destroy
    @author_award.destroy
    respond_with(@author_award)
  end

  private
    def set_author_award
      @author_award = AuthorAward.find(params[:id])
    end

    def author_award_params
      params.require(:author_award).permit(:author_id, :prize_id, :year)
    end
end
