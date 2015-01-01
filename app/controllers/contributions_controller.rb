class ContributionsController < ApplicationController
  before_action :set_contribution, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @contributions = Contribution.all.page(params[:page])
    respond_with(@contributions)
  end

  def show
    respond_with(@contribution)
  end

  def new
    @jobs = Contribution.jobs
    @contribution = Contribution.new    
    respond_with(@contribution)
  end

  def edit
    @jobs = Contribution.jobs
  end

  def create
    @contribution = Contribution.new(contribution_params)
    @contribution.save
    respond_with(@contribution)
  end

  def update
    @contribution.update(contribution_params)
    respond_with(@contribution)
  end

  def destroy
    @contribution.destroy
    respond_with(@contribution)
  end

  private
    def set_contribution
      @contribution = Contribution.find(params[:id])
    end

    def contribution_params
      params.require(:contribution).permit(:job, :book_id, :author_id)
    end
end
