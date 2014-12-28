json.array!(@prizes) do |prize|
  json.extract! prize, :id, :name
  json.url prize_url(prize, format: :json)
end
