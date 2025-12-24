require 'open-uri'
require 'nokogiri'
require 'net/http'
require 'json'
require_relative 'airtable_helper'

def fetch_infos(link)
  infos_hash = {}
  html_detail = URI.open(link).read
  doc_detail = Nokogiri::HTML(html_detail)

  infos_hash[:image_link] = doc_detail.css('.single-biere-image-inner img').attribute('src').value.strip
  infos_hash[:name] = doc_detail.css('h1.title').text.strip
  infos_hash[:category] = doc_detail.css('h3.type').first.text.strip
  infos_hash[:ibu] = doc_detail.css('.ibu-bold').text.strip.to_i
  infos_hash[:long_desc] = doc_detail.css('.description').children.first.text.strip
  infos_hash[:alc_percent] = doc_detail.css('.alcool').children.last.text.strip

  infos_hash
end

def scrape_farnham
  url = "https://farnham-alelager.com/bieres/"
  html = URI.open(url).read
  doc = Nokogiri::HTML(html)

  brewery = Brewery.find_or_initialize_by(name: "Farnham")
  brewery.save!

  links = doc.search(".biere").map do |beer_card|
    beer_card.css('a').attribute('href').value
  end

  details = links.map { |link| fetch_infos(link) }

  response = AirtableHelper.new(
    table_id: 'tblmlmhM45tEEp8yc',
    data: details
  ).save_to_airtable
  p response
end

def load_farnham
  response = AirtableHelper.new(
    table_id: 'tblmlmhM45tEEp8yc',
    brewery_name: 'Farnham'
  ).fetch_from_airtable

  p response
end
