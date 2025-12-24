# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'
# require_relative 'beer'

def scrape_hermite
  url = 'https://microhermite.com'
  html = URI.open(url).read
  doc = Nokogiri::HTML(html)

  container = doc.search('#widget-2d8f2c3d-5e88-4b8a-859d-6cc800061f26')

  img_links = container.search('span.image-block').map do |partial_link|
    clean_partial = partial_link.children.attribute('src').value.gsub('../..', '')
    "https://microhermite.com#{clean_partial}"
  end

  clean_groups = []

  all_ps = container.search('p').map { |each_p| each_p.text.strip }
  grouped = all_ps.split { |str| str == '' }

  grouped.each do |group|
    group.reject! { |el| el.length == 1 }
    clean_groups << group unless group.count.zero?
  end

  infos = []

  clean_groups.each_with_index do |group, index|
    next if group.count == 1

    att = {}
    att[:name] = group.first
    att[:image_link] = img_links[index]
    att[:short_desc] = group[-2]

    group.each do |string|
      att[:ibu] = string.gsub('IBU: ', '').to_i if string.start_with?('IBU: ')
      att[:alc_percent] = string.gsub('Alcool: ', '').delete_suffix('%') if string.start_with?('Alcool: ')
    end

    infos << att
  end

  brewery = Brewery.find_or_initialize_by(name: "L'Hermite")
  brewery.save!

  infos.each do |beer_hash|
    beer = Beer.new(beer_hash)

    photo_file = URI.open(beer_hash[:image_link])
    beer.photo.attach(io: photo_file, filename: beer_hash[:name].to_s, content_type: 'image/jpg')

    beer.brewery = brewery

    beer.save!
  end
end
