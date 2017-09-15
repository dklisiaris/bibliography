class Api::V1::CategoryWithBooksSerializer < Api::V1::BaseSerializer
  attributes :id, :name, :ddc, :slug, :biblionet_id, :featured, :url, :site_url, :books

  # has_many :books, serializer: Api::V1::Minimal::BookSerializer

  def books
    object.books.where.not(image: nil).order({views_count: :desc}).limit(12).map do |book|
      Api::V1::Minimal::BookSerializer.new(book, scope: scope, root: false)
    end
  end

end
