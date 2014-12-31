json.array!(@awards) do |award|
  json.extract! award, :id, :prize_id, :year, :awardable_id, :awardable_type
  json.url award_url(award, format: :json)
end
