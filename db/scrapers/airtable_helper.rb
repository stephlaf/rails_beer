require 'net/http'
require 'json'

class AirtableHelper
  def initialize(attributes = {})
    @table_id = attributes[:table_id]
    @data = attributes[:data]
    @brewery = Brewery.find_by_name(attributes[:brewery_name])
  end

  def download_to_file(uri)
    begin
      stream = URI.open(uri, "rb")
      return stream if stream.respond_to?(:path) # Already file-like
    rescue OpenURI::HTTPError
      return File.open(File.join(Rails.root, "/app/assets/images/default_beer.png"))
    end

    Tempfile.new.tap do |file|
      file.binmode
      IO.copy_stream(stream, file)
      stream.close
      file.rewind
    end
  end

  def save_to_airtable
    uri = URI("https://api.airtable.com/v0/app6obkoVGtmGxLc0/#{@table_id}")
    req = Net::HTTP::Post.new(uri)
    req.content_type = 'application/json'
    req['Authorization'] = "Bearer #{ENV['AIRTABLE_TOKEN']}"

    req_options = {
      use_ssl: uri.scheme == 'https'
    }

    records = @data.map do |beer|
      {
        'fields' => {
          'name' => beer[:name],
          'long_desc' => beer[:long_desc],
          'category' => beer[:category],
          'image_link' => beer[:image_link],
          'ibu' => beer[:ibu],
          'alc_percent' => beer[:alc_percent]
        }
      }
    end

    req.body = { 'records' => records }.to_json

    res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(req)
    end

    res
  end

  def fetch_from_airtable
    uri = URI("https://api.airtable.com/v0/app6obkoVGtmGxLc0/#{@table_id}")
    params = {
      # :maxRecords => '3',
      :view => 'Grid view',
    }
    uri.query = URI.encode_www_form(params)

    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = "Bearer #{ENV["AIRTABLE_TOKEN"]}"
    req_options = { use_ssl: uri.scheme == 'https' }

    res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(req)
    end

    beers = JSON.parse(res.body)

    beers['records'].each do |beer_infos|
      beer = Beer.new(beer_infos['fields'])
      beer.brewery = @brewery
      beer.save!

      unless beer_infos['fields']['image_link'].nil?
        photo_file = download_to_file(beer_infos['fields']['image_link'])
        beer.photo.attach(io: photo_file, filename: "#{beer.name}", content_type: 'image/jpg')
        beer.save!
      end

      puts "#{beer.brewery.name}'s #{beer.name} with id #{beer.id} was created"
    end
    "Done loading #{@brewery.name}'s beers to the database"
  end
end
