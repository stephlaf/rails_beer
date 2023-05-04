require 'open-uri'
require 'nokogiri'
require 'csv'

def scrape_dieu_du_ciel
  url = "https://dieuduciel.com/categories/en-bouteille/"
  html = URI.open(url).read
  doc = Nokogiri::HTML(html)

  puts "Getting links for Dieu du Ciel!..."

  links = doc.search('.product-item').map do |element|
    element.attribute('data-href').value
  end

  puts "Creating Dieu du Ciel! beers..."

  brewery = Brewery.find_by(name: "Dieu du Ciel!")

  links.each do |link|
    html = open(link).read
    doc = Nokogiri::HTML(html)

    att = {}
    name = doc.search('.h2-inner').text.strip
    image_link = doc.search('img').attribute('src').value

    photo_file = URI.open(image_link)

    att[:name] = name
    att[:image_link] = image_link
    att[:alc_percent] = doc.search('.abv').text.strip.delete_suffix("% alc./vol.")
    att[:short_desc] = doc.search('.short-desc p').text.strip
    att[:long_desc] = doc.search('.long-desc-inner p').text.strip
    # att[:upc] = upcs[counter]

    beer = Beer.new(att)
    beer.photo.attach(io: photo_file, filename: "#{name}", content_type: 'image/jpg')

    beer.brewery = brewery

    beer.save!

    # counter = 0
    # upcs = %w[4902125189003 0011391001897 0011391001835 14214267-000499 0060383857974 7630054475702 7630054474606]

    # counter += 1
  end
end
