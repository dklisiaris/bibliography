json.array!(@authors) do |author|
  json.extract! author, :id, :firstname, :lastname, :extra_info, :biography, :image
  json.url author_url(author, format: :json)
end
