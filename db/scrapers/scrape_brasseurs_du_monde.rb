require 'open-uri'
require 'nokogiri'

def scrape_brasseurs_du_monde
  url = "https://brasseursdumonde.com/nos-bieres/"
  html = URI.open(url).read
  doc = Nokogiri::HTML(html)
  suffix = "Inscrivez-vous à notre infolettre!© 2020 | Brasseurs du monde"

  puts "Getting links for Brasseurs du Monde..."

  rejects = [
    "12 mixte Sympathique",
    "12 Mixte Connaisseur",
    "Coffret Grand Connaisseur",
    "4 Mixte Dégluténisées",
    "Boîtiers-cadeaux 2018",
    "Boîtiers-cadeaux 2019",
    "2016",
    "2017"
  ]

  link_pairs = []

  doc.search('.elementor-post__thumbnail__link').each do |element|
    unless rejects.include?(element.text.strip)
      pair = {
        link: element.attribute('href').value,
        image_link: element.children.children[1].attribute('src').value
      }
      link_pairs << pair
    end
  end

  puts "Creating Brasseurs du Monde beers..."

  brewery = Brewery.find_by(name: "Brasseurs du Monde")

  link_pairs.each do |link_pair|
    html = open(link_pair[:link]).read
    doc = Nokogiri::HTML(html)

    att = {}
    name = doc.search('h1.elementor-heading-title').text.strip
    image_link = link_pair[:image_link]

    photo_file = URI.open(image_link)

    att[:name] = name
    att[:image_link] = image_link
    # att[:alc_percent] = doc.search('.abv').text.strip
    # att[:short_desc] = doc.search('.short-desc p').text.strip
    att[:long_desc] = doc.search('.elementor-widget-container p').text.strip.delete_suffix(suffix)

    beer = Beer.new(att)
    beer.photo.attach(io: photo_file, filename: "#{name}", content_type: 'image/jpg')

    beer.brewery = brewery
    beer.save!
  end
end
