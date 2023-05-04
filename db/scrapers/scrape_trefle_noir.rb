require 'open-uri'
require 'nokogiri'

def download_to_file(uri)
  stream = open(uri, "rb")
  return stream if stream.respond_to?(:path) # Already file-like

  Tempfile.new.tap do |file|
    file.binmode
    IO.copy_stream(stream, file)
    stream.close
    file.rewind
  end
end

def scrape_trefle_noir
  url = "https://letreflenoir.com/pages/nos-bieres"
  html = URI.open(url).read
  doc = Nokogiri::HTML(html)

  good_indices = [0, 4, 5, 6]

  puts "Creating Trefle Noir beers..."

  brewery = Brewery.find_by(name: "Le Trèfle Noir Microbrasserie")

  counter = 1

  doc.search('.txtNew').each do |element|
    infos = []
    att = {}

    element.children.text.split("\n\n").each_with_index do |string, index|
      if good_indices.include?(index)
        infos << string.split(":").last.strip.gsub(/[[:space:]]/, ' ').gsub('%', '').strip
      end
    end

    att[:name] = infos.first
    att[:alc_percent] = infos[1].to_i
    att[:category] = infos[2]
    att[:long_desc] = infos.last

    doc.search('wix-image img').each do |element|
      beer_name = element.attribute('alt').value.split('.').first
      # att[:name].gsub(' ', '').downcase

      if beer_name == att[:name].gsub(' ', '_').gsub('è', 'e').gsub("'", '').downcase || beer_name == 'Trefle' && att[:name].split.first == 'Trèfle'
        att[:image_link] = element.attribute('src').value.gsub(',blur_3', '')
      end
    end

    unless att[:image_link].nil?
      photo_file = download_to_file(att[:image_link])

      beer = Beer.new(att)
      # p counter
      beer.photo.attach(io: photo_file, filename: "#{att[:name]}", content_type: 'image/jpg')

      beer.brewery = brewery

      beer.save!
    end
  end
end
