require 'open-uri'
require 'nokogiri'

def scrape_farnham
  url = "https://farnham-alelager.com/"
  html = URI.open(url).read
  doc = Nokogiri::HTML(html)

  brewery = Brewery.find_or_initialize_by(name: "Farnham")
  brewery.save!

  infos = []
  counter = 1

  8.times do
    doc.search("#sample_slider_slide0#{counter}").map do |element|
      name = element.search('h3').text.strip.titleize

      short_desc = element.search('p strong').text.strip
      dirty_long_desc = element.search('p').text.strip

      image_link = element.children.children.attribute('src').value
      # photo_file = URI.open(image_link)

      att = {
        image_link: image_link,
        name: name,
        short_desc: short_desc,
        long_desc: dirty_long_desc.gsub(short_desc, ''),
        category: name.split('|').last.strip,
        ibu: name.split('|').first.strip
      }

      infos << att

      # beer = Beer.new(att)
      # beer.photo.attach(io: photo_file, filename: "#{name}", content_type: 'image/jpg')

      # beer.brewery = brewery

      # beer.save!

      counter += 1
    end
  end
  store_csv(infos)
end

def store_csv(infos)
  csv_options = { col_sep: ',', force_quotes: true, quote_char: '"' }
  filepath    = File.join(__dir__, 'farnham.csv')

  CSV.open(filepath, 'wb', csv_options) do |row|
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
  end
end
