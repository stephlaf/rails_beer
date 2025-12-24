# frozen_string_literal: true

json.array! @beers do |beer|
  json.extract! beer,
                :id,
                :name,
                :rating,
                :brewery_id,
                :ibu,
                :image_link,
                :alc_percent,
                :short_desc,
                :long_desc,
                :upc,
                :category
end
