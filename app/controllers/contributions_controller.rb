class ContributionsController < ApplicationController
  before_action :set_contribution, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @contributions = policy_scope(Contribution).page(params[:page])
    authorize Contribution

    respond_with(@contributions)
  end

  def show
    respond_with(@contribution)
  end

  def new
    @jobs = Contribution.jobs
    @contribution = Contribution.new
    authorize @contribution

    respond_with(@contribution)
  end

  def edit
    @jobs = Contribution.jobs
  end

  def create
    @contribution = Contribution.new(contribution_params)
    authorize @contribution    
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

      authorize @contribution
    end

    def contribution_params
      params.require(:contribution).permit(:job, :book_id, :author_id)
    end
end
