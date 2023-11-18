# frozen_string_literal: true

require 'csv'

def upc_assign
  filepath = File.join(__dir__, 'upcs.csv')
  csv_options = { col_sep: ',', headers: :first_row, header_converters: :symbol }

  CSV.foreach(filepath, csv_options) do |row|
    beer = Beer.find_by(name: row[:beer_name])
    brewery = Brewery.find_by(name: row[:brewery_name])

    if beer && beer.brewery == brewery
      beer.upc = row[:upc]
      beer.save!
    end
  end
end

# # counter = 0
# # upcs = %w[4902125189003 0011391001897 0011391001835 14214267-000499 0060383857974 7630054475702 7630054474606]
# # beers = Beer.all

# # upcs.count.times do
# #   random_beer = beers.sample
# #   random_beer.upc = upcs[counter]
# #   random_beer.save!

# #   counter += 1
# # end
