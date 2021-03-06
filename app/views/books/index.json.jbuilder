json.array!(@books) do |book|
  json.extract! book, :id, :title, :subtitle, :description, :image, :isbn, :isbn13, :ismn, :issn, :series, :pages, :publication_year, :publication_place, :price, :price_updated_at, :physical_description, :cover_type, :availability, :format, :original_language, :original_title, :publisher_id, :extra, :biblionet_id
  json.url book_url(book, format: :json)
end
