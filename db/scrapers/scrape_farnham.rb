require 'open-uri'
require 'nokogiri'
require_relative 'fetch_image'

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
  details.each do |detail|
    beer = Beer.new(detail)
    beer.brewery = brewery

    unless detail[:image_link].nil?
      photo_file = FetchImage.new(detail[:image_link]).download_to_file
      beer.photo.attach(io: photo_file, filename: "#{beer.name}", content_type: 'image/jpg')
    end

    beer.save!

    puts "#{beer.brewery.name}'s #{beer.name} with id #{beer.id} was created"
  end
end

# Previous version, kept in case

def store_csv(infos)
  csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
  filepath    = File.join(__dir__, 'farnham.csv')

  CSV.open(filepath, 'wb', col_sep: ',', force_quotes: true, quote_char: '"') do |row|
    row << ['image_link', 'name', 'short_desc', 'long_desc', 'category', 'ibu']
    infos.each do |beer|
      row << [beer[:image_link], beer[:name], beer[:short_desc], beer[:long_desc], beer[:category], beer[:ibu]]
    end
  end
end

def load_csv
  puts "Loading Farnham beers from CSV..."

  brewery = Brewery.find_or_initialize_by(name: 'Farnham')
  brewery.save!

  csv_options = { headers: :first_row, header_converters: :symbol }
  csv_file = File.join(__dir__, 'farnham.csv')

  CSV.foreach(csv_file, csv_options) do |row|
    row[:ibu]    = row[:ibu].to_i

    beer = Beer.new(row.to_h)

    photo_file = URI.open(row[:image_link])
    beer.photo.attach(io: photo_file, filename: "#{row[:name]}", content_type: 'image/jpg')

    beer.brewery = brewery

    beer.save!
    puts "Beer with id #{beer.id} was created"
  end
end
