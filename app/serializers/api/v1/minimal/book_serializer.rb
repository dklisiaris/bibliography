class Api::V1::Minimal::BookSerializer < Api::V1::BaseSerializer
  attributes :id, :title, :subtitle, :description, :cover, :url, :site_url

  def description
    object.short_description(100)
  end

  def cover
    object.cover
  end

end
