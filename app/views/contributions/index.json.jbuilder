json.array!(@contributions) do |contribution|
  json.extract! contribution, :id, :job, :book_id, :author_id
  json.url contribution_url(contribution, format: :json)
end
