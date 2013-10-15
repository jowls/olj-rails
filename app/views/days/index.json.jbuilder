json.array!(@days) do |day|
  json.extract! day, :date, :content, :user_id
  json.url day_url(day, format: :json)
end
