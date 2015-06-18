class Api::V1::PublisherSerializer < Api::V1::BaseSerializer
  attributes :id, :name, :owner, :slug, :url, :created_at, :updated_at

  has_many :places

end