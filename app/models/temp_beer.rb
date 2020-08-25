class TempBeer < ApplicationRecord
  has_one_attached :photo

  validates :name, :brewery_name, :upc, presence: true
end
