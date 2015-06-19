class Api::V1::AuthorSerializer < Api::V1::BaseSerializer
  attributes :id, :firstname, :lastname, :extra_info, :biography, :image, :biblionet_id, :url, :site_url, :created_at, :updated_at

end