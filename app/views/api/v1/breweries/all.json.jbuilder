# frozen_string_literal: true

json.array! @breweries do |brewery|
  json.extract! brewery,
                :id,
                :name
end
