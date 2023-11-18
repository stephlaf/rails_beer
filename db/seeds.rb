# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
require 'csv'

require_relative 'scrapers/load_breweries'
require_relative 'scrapers/scrape_brasseurs_du_monde'
require_relative 'scrapers/scrape_dieu_du_ciel'
require_relative 'scrapers/scrape_farnham'
require_relative 'scrapers/scrape_trefle_noir'
require_relative 'scrapers/scrape_hermite'
require_relative 'scrapers/scrape_grimoire'
require_relative 'scrapers/upc_assign'

# ______________________________________
# BEER TABS

# puts 'Destroying all beer tabs...'
# BeerTab.destroy_all

# ______________________________________
# USERS

# puts 'Destroying all users...'
# User.destroy_all

# puts 'Creating users...'

# names = %w[a b c d e]
# user_counter = 0

# 5.times do
#   User.create!(email: "#{names[user_counter]}@#{names[user_counter]}.#{names[user_counter]}", password: '123456')
#   user_counter += 1
# end

# ________________________________________
# BREWERIES

# puts 'Destroying all breweries...'
# Brewery.destroy_all

# puts 'Loading all breweries...'
# load_breweries

# Brewery.all

# ________________________________________
# BEERS

# puts 'Destroying all beers...'
# Beer.destroy_all

# ________________________________________
# BEERS Dieu du Ciel!

# load_ddc
# puts 'Done Dieu du Ciel! 🍻'

# ____________________________________________________
# BEERS Farnham

# scrape_farnham
# load_farnham
# puts 'Done Farnham 🍻'

# ____________________________________________________
# BEERS Trefle Noir

# scrape_trefle_noir
# load_trefle_noir
# puts 'Done Trefle Noir 🍻'

# ____________________________________________________
# BEERS Brasseurs du Monde

# scrape_brasseurs_du_monde
# puts 'Done Brasseurs du Monde 🍻'

# ____________________________________________________
# BEERS Hermite

# scrape_hermite
# puts 'Done Hermite 🍻'

# ____________________________________________________
# BEERS Grimoire

# scrape_grimoire
# puts 'Done Grimoire 🍻'

# ___________________________________________________
# UPCs assign
# puts 'Assigning UPCs...'
# upc_assign

# # ____________________________________________________
# # UPCs Randomize

puts 'All done 😃'
