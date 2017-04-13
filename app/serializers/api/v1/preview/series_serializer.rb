class Api::V1::Preview::SeriesSerializer < Api::V1::BaseSerializer
  attributes :id, :name, :url, :site_url

  def site_url
    books_url(series: name)
  end
end
