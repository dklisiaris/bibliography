class SeriesController < ApplicationController
  respond_to :html

  # impressionist :actions=>[:index]

  def index

    @series = policy_scope(Series).page(params[:page])
    respond_with(@series)
  end

  private
    def publisher_params
      params.require(:series).permit(:name)
    end

end
