json.array!(@shelves) do |shelf|
  json.extract! shelf, :id, :name, :privacy, :built_in, :active, :user_id
  json.url shelf_url(shelf, format: :json)
end
