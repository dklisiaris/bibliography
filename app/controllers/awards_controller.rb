class AwardsController < ApplicationController
  before_action :set_award, only: [:show, :edit, :update, :destroy]
  before_action :load_awardable, except: [:index]

  respond_to :html

  def index
    @awards = Award.all.page(params[:page])
    respond_with(@awards)
  end

  def show
    respond_with(@award)
  end


  def edit    
  end

  def create
    @award = @awardable.awards.new(award_params)
    flash[:notice] = "Award created successfully!" if @award.save
    respond_with(@awardable)
  end

  def update
    flash[:notice] = "Award updated successfully!" if @award.update(award_params)
    respond_with(@awardable)
  end

  def destroy
    flash[:notice] = "Award deleted successfully!" if @award.destroy
    respond_with(@awardable)
  end

  private
    def set_award
      @award = Award.find(params[:id])
    end

    def award_params
      params.require(:award).permit(:prize_id, :year, :awardable_id, :awardable_type)
    end

    def load_awardable
      resource, id = request.path.split('/')[1,2]
      @awardable = resource.singularize.classify.constantize.find(id)
    end    
end
