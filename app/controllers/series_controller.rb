class SeriesController < ApplicationController
  respond_to :html

  def index
    if params[:q].present?
      keyphrase = ApplicationController.helpers.latinize(params[:q])
      limit = params[:autocomplete].try(:to_i) == 1 ? 8 : 50

      @series = policy_scope(Series)
        .search(keyphrase, body_options: {min_score: 0.1}, order: {_score: :desc},
          page: params[:page], per_page: limit)
    else
      @series = policy_scope(Series).page(params[:page])
    end

    if params[:autocomplete].try(:to_i) == 1 and params[:q].present?
      render json: @series, each_serializer: Api::V1::Preview::SeriesSerializer, root: false
    else
      respond_with(@series)
    end
  end

  private
    def series_params
      params.require(:series).permit(:name)
    end

end
