class Api::V1::CategoryWithBooksSerializer < Api::V1::BaseSerializer
  attributes :id, :name, :ddc, :slug, :biblionet_id, :featured, :url, :site_url, :created_at, :updated_at

  # has_many :books, serializer: Api::V1::Preview::BookSerializer, limit: 5

end
