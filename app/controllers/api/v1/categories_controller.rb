class Api::V1::CategoriesController < Api::V1::BaseController
  before_filter :authenticate_user_from_token!, only: [:liked_with_books]

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
    if user_signed_in? && current_user.liked_categories_count > 0
      categories = current_user.liked_categories.includes(:books)
    else
      categories = Category.featured.includes(:books)
    end

    categories = policy_scope(categories)
    categories = paginate(categories)
    categories = apply_filters(categories, params)

    render(
      json: categories,
      each_serializer: Api::V1::CategoryWithBooksSerializer,
      root: 'categories',
      meta: meta_attributes(categories),
    )
  end

  def show
    category = Category.find(params[:id])

    response = apply_format(Api::V1::CategorySerializer.new(category))

    render(json: response)
  end
end
