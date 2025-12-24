# frozen_string_literal: true

class Beer < ActiveRecord::Base
  has_many :beer_tabs, dependent: :destroy
  belongs_to :brewery

  has_one_attached :photo

  scope :order_by_name, -> { order(name: :asc) }

  include PgSearch::Model

  pg_search_scope :global_search,
                  against: {
                    category: 'A',
                    name: 'B',
                    short_desc: 'C',
                    long_desc: 'D'
                  },
                  ignoring: :accents,
                  associated_against: {
                    brewery: [:name]
                  },
                  using: {
                    tsearch: { prefix: true }
                  }
end
