class Api::V1::Preview::BookSerializer < Api::V1::BaseSerializer
  attributes :id,:title, :subtitle, :description, :image, :likes_count, :dislikes_count, :collections_count, :views_count, :url, :site_url

  has_many :writers, serializer: Api::V1::Preview::AuthorSerializer
  has_one :publisher, serializer: Api::V1::Preview::PublisherSerializer
  has_many :categories, serializer: Api::V1::Preview::CategorySerializer

  def description
    object.short_description(100)
  end

  def image
    object.uploaded_cover_url.presence || '/no_cover.jpg'
  end

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

end