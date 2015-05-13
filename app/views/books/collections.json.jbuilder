json.array!(@shelves) do |shelf|
  if shelf.active
    json.extract! shelf, :id, :screen_name, :user_id
    json.url shelf_url(shelf, format: :json)
  end
end