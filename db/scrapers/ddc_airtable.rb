require 'open-uri'
require 'json'
require 'net/http'

def fetch_ddc_from_airtable
  uri = URI('https://api.airtable.com/v0/app6obkoVGtmGxLc0/DDC%20Beers')
  params = {
    # :maxRecords => '3',
    :view => 'Grid view',
  }
  uri.query = URI.encode_www_form(params)

  req = Net::HTTP::Get.new(uri)
  req['Authorization'] = "Bearer #{ENV["AIRTABLE_TOKEN"]}"

  req_options = {
    use_ssl: uri.scheme == 'https'
  }
  res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
    http.request(req)
  end

  beers = JSON.parse(res.body)

  beers['records'].each do |beer_infos|
    beer = Beer.new(beer_infos['fields'])
    beer.brewery = Brewery.find_by_name('Dieu du Ciel!')
    beer.save!
    puts "Beer with id #{beer.id} was created"
  end
end