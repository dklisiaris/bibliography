class SeriesController < ApplicationController
  respond_to :html

  def index
    if params[:q].present?
      keyphrase = ApplicationController.helpers.latinize(params[:q])
      limit = params[:autocomplete].try(:to_i) == 1 ? 8 : 50

      # Searchkick search must be called on model class, not relation
      @series = Series.search(keyphrase, body_options: {min_score: 0.1}, order: {_score: :desc},
          page: params[:page], per_page: limit)
      # Call policy_scope for Pundit verification (even though it doesn't filter in this case)
      policy_scope(Series)
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
