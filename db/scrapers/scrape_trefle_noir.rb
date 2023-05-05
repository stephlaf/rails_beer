require 'open-uri'
require 'nokogiri'

def download_to_file(uri)
  stream = URI.open(uri, "rb")
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

    # pp infos_hash

    att = {}

    att[:name] = element.css('h3.image-with-text__heading.h1').text.strip
    att[:image_link] = "https:#{element.css('figure > img.img').attribute('src').value}"
    att[:long_desc] = element.css('.image-with-text__description p').last.text.strip
    att[:alc_percent] = infos_hash[:alcool]
    att[:category] = infos_hash[:type]
    att[:ibu] = infos_hash[:ibu].to_i

    # pp att

    unless att[:image_link].nil?
      photo_file = download_to_file(att[:image_link])
      beer = Beer.new(att)
      beer.photo.attach(io: photo_file, filename: "#{att[:name]}", content_type: 'image/jpg')
      beer.brewery = brewery
      beer.save!
    end
  end
end
