class Api::V1::CategoriesController < Api::V1::BaseController
  def show
    category = Category.find(params[:id])    

    response = apply_format(Api::V1::CategorySerializer.new(category))
    
    render(json: response)
  end
end