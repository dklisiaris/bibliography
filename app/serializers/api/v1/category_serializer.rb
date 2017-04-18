 class Api::V1::CategorySerializer < Api::V1::BaseSerializer
  attributes :id, :name, :ddc, :slug, :biblionet_id, :featured, :url, :site_url, :created_at, :updated_at

  has_one :parent, serializer: Api::V1::Preview::CategorySerializer
  has_many :children, serializer: Api::V1::Preview::CategorySerializer

end
