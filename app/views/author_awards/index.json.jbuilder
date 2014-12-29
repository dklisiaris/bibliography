json.array!(@author_awards) do |author_award|
  json.extract! author_award, :id, :author_id, :prize_id, :year
  json.url author_award_url(author_award, format: :json)
end
