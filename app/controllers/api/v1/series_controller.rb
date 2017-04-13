class Api::V1::SeriesController < Api::V1::BaseController
  def show
    series = Series.find(params[:id])

    response = apply_format(Api::V1::SeriesSerializer.new(series))

    render(json: response)
  end
end
