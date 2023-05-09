require 'open-uri'
require 'nokogiri'
require 'net/http'
require 'json'
require_relative 'airtable_helper'

def scrape_trefle_noir
  url = "https://letreflenoir.com/pages/nos-bieres"
  html = URI.open(url).read
  doc = Nokogiri::HTML(html)

  puts "Creating Trefle Noir beers..."

  brewery = Brewery.find_by(name: "Le Trèfle Noir Microbrasserie")
  counter = 1

  details = doc.search('.image-with-text').map do |element|
    counter = 1
    infos_array = element.css('.image-with-text__description p').first.children.map do |child|
      if counter == 1
        counter = 2
        child.children.text.strip
      elsif counter == 2
        counter = 3
        child.text
      elsif counter == 3
        counter = 1
        nil
      end
    end

    infos_hash = {}
    infos_array.compact.each_slice(2) do |slice|
      infos_hash[slice.first.downcase.to_sym] = slice.last.gsub(': ', '')
    end

    att = {}

    att[:name] = element.css('h3.image-with-text__heading.h1').text.strip
    att[:image_link] = "https:#{element.css('figure > img.img').attribute('src').value}"
    att[:long_desc] = element.css('.image-with-text__description p').last.text.strip
    att[:alc_percent] = infos_hash[:alcool]
    att[:category] = infos_hash[:type]
    att[:ibu] = infos_hash[:ibu].to_i

    att
  end

  response = AirtableHelper.new(
    table_id: 'tbleZs7nvjrIf9gUe',
    data: details
  ).save_to_airtable
  p response
end

def load_trefle_noir
  response = AirtableHelper.new(
    table_id: 'tbleZs7nvjrIf9gUe',
    brewery_name: 'Le Trèfle Noir Microbrasserie'
  ).fetch_from_airtable

  p response
end
