class Api::V1::CategoriesController < Api::V1::BaseController
  def index
    categories = policy_scope(Category)
    categories = paginate(categories)
    categories = apply_filters(categories, params)

    render(
      json: categories,
      each_serializer: Api::V1::CategorySerializer,
      root: 'categories',
      meta: meta_attributes(categories)
    )
  end

  def liked_with_books
    categories = policy_scope(Category).featured
    categories = paginate(categories)
    categories = apply_filters(categories, params)

    render(
      json: categories,
      each_serializer: Api::V1::CategoryWithBooksSerializer,
      root: 'categories',
      meta: meta_attributes(categories)
    )
  end

  def show
    category = Category.find(params[:id])

    response = apply_format(Api::V1::CategorySerializer.new(category))

    render(json: response)
  end
end
