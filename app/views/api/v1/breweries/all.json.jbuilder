json.array! @breweries do |brewery|
  json.extract! brewery, :id,
                         :name
end
