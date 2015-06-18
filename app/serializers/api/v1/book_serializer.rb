class Api::V1::BookSerializer < Api::V1::BaseSerializer
  attributes :id, :title, :subtitle, :description, :image, :isbn, :isbn13, :ismn, :issn, :series_name, :series_volume, :pages, :size, :cover_type, :publication_year, :publication_version, :publication_place, :price, :price_updated_at, :availability, :format, :language, :original_language, :original_title, :publisher_id, :extra, :biblionet_id, :slug, :created_at, :updated_at, :likes_count, :dislikes_count, :collections_count, :views_count, :viewers_count, :url

  has_many :writers, serializer: Api::V1::Preview::AuthorSerializer
  has_many :contributors, serializer: Api::V1::Preview::AuthorSerializer
  has_one :publisher, serializer: Api::V1::Preview::PublisherSerializer
  has_many :categories, serializer: Api::V1::Preview::CategorySerializer

  def likes_count
    object.liked_by_count
  end

  def dislikes_count
    object.disliked_by_count
  end  

  def collections_count
    object.bookshelves.count
  end

  def views_count
    object.impressionist_count
  end

  def viewers_count
    object.impressions_count
  end

end
