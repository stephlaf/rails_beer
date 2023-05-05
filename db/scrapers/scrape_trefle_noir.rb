require 'open-uri'
require 'nokogiri'
require_relative 'fetch_image'

def scrape_trefle_noir
  url = "https://letreflenoir.com/pages/nos-bieres"
  html = URI.open(url).read
  doc = Nokogiri::HTML(html)

  puts "Creating Trefle Noir beers..."

  brewery = Brewery.find_by(name: "Le Trèfle Noir Microbrasserie")
  counter = 1

  doc.search('.image-with-text').each do |element|
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

    unless att[:image_link].nil?
      photo_file = FetchImage.new(att[:image_link]).download_to_file
      beer = Beer.new(att)
      beer.photo.attach(io: photo_file, filename: "#{att[:name]}", content_type: 'image/jpg')
      beer.brewery = brewery
      beer.save!
    end

    puts "#{beer.brewery.name}'s #{beer.name} with id #{beer.id} was created"
  end
end
