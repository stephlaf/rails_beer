# frozen_string_literal: true

class Brewery < ApplicationRecord
  has_many :beers, dependent: :destroy

  scope :order_by_name, -> { order(name: :asc) }
end
