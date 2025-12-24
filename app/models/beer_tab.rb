# frozen_string_literal: true

class BeerTab < ApplicationRecord
  belongs_to :user
  belongs_to :beer
end
