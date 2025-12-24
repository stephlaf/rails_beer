# frozen_string_literal: true

# require 'open-uri'
# require 'nokogiri'
# require 'csv'

# def scrape_grimoire
#   reg_url = "https://www.grimoire.biz/gamme-reguliere"
#   reg_html = open(reg_url).read
#   reg_doc = Nokogiri::HTML(reg_html)

#   puts "Getting image links for Grimoire!..."
#   image_links = []

#   reg_doc.search('img').each do |element|
#     if element.attribute('alt').value.match('mockup')
#       image_links << element.attribute('src').value.strip.gsub(',blur_3', '')
#     end
#   end

#   image_links << "https://static.wixstatic.com/media/e69fa4_c01acd8a8c1844a4b7508a69a3bdfb53~mv2.png/v1/fill/w_87,h_208,al_c,q_85,usm_0.66_1.00_0.01/Milkshake-Cherry.webp"
#   image_links << "https://static.wixstatic.com/media/e69fa4_f44c874e6e8349a49631b11e3714b643~mv2.png/v1/fill/w_83,h_214,al_c,q_85,usm_0.66_1.00_0.01/Lager_blonde.webp"
#   image_links << "https://static.wixstatic.com/media/e69fa4_969b7d79ade946d9a4c98654399a529a~mv2.png/v1/fill/w_83,h_214,al_c,q_85,usm_0.66_1.00_0.01/Lager_roussse.webp"

#   puts "Creating Grimoire beers..."

#   brewery = Brewery.find_by(name: "Le Grimoire")

#     att = {}
#     name = "Vie de Château"
#     image_link = image_links[0]

#     photo_file = URI.open(image_link)

#     att[:name] = name
#     att[:category] = "Ambrée au rhum"
#     att[:image_link] = image_link
#     att[:alc_percent] = '7.0'
#     att[:short_desc] = ''
#     att[:long_desc] = "Prestigieuse et accessible, cette ambrée au caractère noble surprend par son originalité et son charisme. Une légère amertume laisse place à un goût de rhum épicé aux accents de vanille qui explose en bouche en vous faisant vivre un plaisir royal!"
#     att[:ibu] = 20

#     beer = Beer.new(att)
#     beer.photo.attach(io: photo_file, filename: "#{name}", content_type: 'image/jpg')

#     beer.brewery = brewery

#     beer.save!

#     att = {}
#     name = "Desérables"
#     image_link = image_links[1]

#     photo_file = URI.open(image_link)

#     att[:name] = name
#     att[:category] = "Ambrée à l'érable"
#     att[:image_link] = image_link
#     att[:alc_percent] = '7.0'
#     att[:short_desc] = ''
#     att[:long_desc] = "Par sa couleur ambrée, douce et scintillante, cette ale aux accents printaniers alimente les désirs et les folles envies. Son goût réconfortant, accompagné d’une subtile amertume, rappelle la saveur ensoleillée d’une délicieuse tire d’érable."
#     att[:ibu] = 20

#     beer = Beer.new(att)
#     beer.photo.attach(io: photo_file, filename: "#{name}", content_type: 'image/jpg')

#     beer.brewery = brewery

#     beer.save!

#     att = {}
#     name = "IPA des Dieux"
#     image_link = image_links[2]

#     photo_file = URI.open(image_link)

#     att[:name] = name
#     att[:category] = "IPA blanche à l'écorce d'orange"
#     att[:image_link] = image_link
#     att[:alc_percent] = '5.0'
#     att[:short_desc] = ''
#     att[:long_desc] = "Cette IPA brassée avec du houblon Brewer's Gold offre une belle amertume accompagnée d'un goût aux notes d'agrumes."
#     att[:ibu] = 30

#     beer = Beer.new(att)
#     beer.photo.attach(io: photo_file, filename: "#{name}", content_type: 'image/jpg')

#     beer.brewery = brewery

#     beer.save!

#     att = {}
#     name = "IPA des Déesses"
#     image_link = image_links[3]

#     photo_file = URI.open(image_link)

#     att[:name] = name
#     att[:category] = "IPA blanche aux framboises et hibiscus"
#     att[:image_link] = image_link
#     att[:alc_percent] = '5.0'
#     att[:short_desc] = ''
#     att[:long_desc] = "Cette IPA brassée avec du houblon Brewer's Gold offre une belle amertume accompagnée d'un bon goût aux notes de framboises."
#     att[:ibu] = 30

#     beer = Beer.new(att)
#     beer.photo.attach(io: photo_file, filename: "#{name}", content_type: 'image/jpg')

#     beer.brewery = brewery

#     beer.save!

#     att = {}
#     name = "Grimousse"
#     image_link = image_links[4]

#     photo_file = URI.open(image_link)

#     att[:name] = name
#     att[:category] = "Rousse caramel et chocolat"
#     att[:image_link] = image_link
#     att[:alc_percent] = '5.0'
#     att[:short_desc] = ''
#     att[:long_desc] = "Les accents de caramel et de chocolat de cette rousse ardente parviennent à en rehausser le goût pour atteindre un niveau inégalable. Le parfait équilibre entre le malt chocolaté et les différents houblons donne à la Grimousse toutes ses lettres de noblesse."
#     att[:ibu] = 20

#     beer = Beer.new(att)
#     beer.photo.attach(io: photo_file, filename: "#{name}", content_type: 'image/jpg')

#     beer.brewery = brewery

#     beer.save!

#     att = {}
#     name = "La Noirceur"
#     image_link = image_links[5]

#     photo_file = URI.open(image_link)

#     att[:name] = name
#     att[:category] = "Stout au chocolat"
#     att[:image_link] = image_link
#     att[:alc_percent] = '5.0'
#     att[:short_desc] = ''
#     att[:long_desc] = "Cette stout à la couleur sombre, apportée par la torréfaction des malts, offre à la fois un petit goût classique de café, mais aussi un bon côté chocolaté savoureux qui saura vous ravir."
#     att[:ibu] = 20

#     beer = Beer.new(att)
#     beer.photo.attach(io: photo_file, filename: "#{name}", content_type: 'image/jpg')

#     beer.brewery = brewery

#     beer.save!

#     att = {}
#     name = "Goliath"
#     image_link = image_links[6]

#     photo_file = URI.open(image_link)

#     att[:name] = name
#     att[:category] = "Brune au brandy"
#     att[:image_link] = image_link
#     att[:alc_percent] = '7.0'
#     att[:short_desc] = ''
#     att[:long_desc] = "Cette bière brune reçoit les éloges pour son arôme enveloppant aux teintes d’alcool de Charente. La subtile saveur de café vous fera revivre l’intimité de certaines soirées apaisantes passées en bonne compagnie."
#     att[:ibu] = 20

#     beer = Beer.new(att)
#     beer.photo.attach(io: photo_file, filename: "#{name}", content_type: 'image/jpg')

#     beer.brewery = brewery

#     beer.save!

#     att = {}
#     name = "Délice Du Lac"
#     image_link = image_links[7]

#     photo_file = URI.open(image_link)

#     att[:name] = name
#     att[:category] = "Blonde aux bleuets"
#     att[:image_link] = image_link
#     att[:alc_percent] = '5.0'
#     att[:short_desc] = ''
#     att[:long_desc] = "Cette bière blonde de type lager, avec une faible amertume, propose un agréable goût de bleuets."
#     att[:ibu] = 20

#     beer = Beer.new(att)
#     beer.photo.attach(io: photo_file, filename: "#{name}", content_type: 'image/jpg')

#     beer.brewery = brewery

#     beer.save!

#     att = {}
#     name = "Lime-Mortelle"
#     image_link = image_links[8]

#     photo_file = URI.open(image_link)

#     att[:name] = name
#     att[:category] = "Blonde à la lime"
#     att[:image_link] = image_link
#     att[:alc_percent] = '5.0'
#     att[:short_desc] = ''
#     att[:long_desc] = "Cette bière blonde  brassée avec de la cardamome possède un goût de lime parfaitement rafraîchissant."
#     att[:ibu] = 20

#     beer = Beer.new(att)
#     beer.photo.attach(io: photo_file, filename: "#{name}", content_type: 'image/jpg')

#     beer.brewery = brewery

#     beer.save!

#     att = {}
#     name = "Milkshake IPA Pina Colada"
#     image_link = image_links[9]

#     photo_file = URI.open(image_link)

#     att[:name] = name
#     # att[:category] = ""
#     att[:image_link] = image_link
#     att[:alc_percent] = '6.0'
#     att[:short_desc] = ''
#     att[:long_desc] = "Cette Milkshake IPA est brassée avec du thé fruité au Pina Colada pour vous offrir un goût aux accents d'ananas et de noix de coco bien équilibré."
#     att[:ibu] = 30

#     beer = Beer.new(att)
#     beer.photo.attach(io: photo_file, filename: "#{name}", content_type: 'image/jpg')

#     beer.brewery = brewery

#     beer.save!

#     att = {}
#     name = "Milkshake Cherry Bomb"
#     image_link = image_links[10]

#     photo_file = URI.open(image_link)

#     att[:name] = name
#     # att[:category] = ""
#     att[:image_link] = image_link
#     att[:alc_percent] = '5.0'
#     att[:short_desc] = ''
#     att[:long_desc] = "Cette Milkshake est brassée avec du thé fruité à la cerise pour vous offrir un bon goût aux accents de cerise."
#     att[:ibu] = 20

#     beer = Beer.new(att)
#     beer.photo.attach(io: photo_file, filename: "#{name}", content_type: 'image/jpg')

#     beer.brewery = brewery

#     beer.save!

#     att = {}
#     name = "Lager blonde"
#     image_link = image_links[11]

#     photo_file = URI.open(image_link)

#     att[:name] = name
#     # att[:category] = ""
#     att[:image_link] = image_link
#     att[:alc_percent] = '4.5'
#     att[:short_desc] = ''
#     att[:long_desc] = "Cette bière blonde de type lager offre un goût léger et frais. Elle est simple et facile à boire."
#     att[:ibu] = 20

#     beer = Beer.new(att)
#     beer.photo.attach(io: photo_file, filename: "#{name}", content_type: 'image/jpg')

#     beer.brewery = brewery

#     beer.save!

#     att = {}
#     name = "Lager rousse"
#     image_link = image_links[12]

#     photo_file = URI.open(image_link)

#     att[:name] = name
#     # att[:category] = ""
#     att[:image_link] = image_link
#     att[:alc_percent] = '4.5'
#     att[:short_desc] = ''
#     att[:long_desc] = "Cette bière rousse de type lager offre un goût léger et frais. Elle est simple et facile à boire."
#     att[:ibu] = 20

#     beer = Beer.new(att)
#     beer.photo.attach(io: photo_file, filename: "#{name}", content_type: 'image/jpg')

#     beer.brewery = brewery

#     beer.save!

# end
