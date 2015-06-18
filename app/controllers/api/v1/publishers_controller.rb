class Api::V1::PublishersController < Api::V1::BaseController
  def show
    publisher = Publisher.find(params[:id])
    impressionist(publisher)

    response = apply_format(Api::V1::PublisherSerializer.new(publisher))
    
    render(json: response)
  end
end