require 'csv'

def create_breweries(array)
  puts "Creating breweries from AMQ list..."

  array.each do |name|
    Brewery.create!(name: name)
  end
end

def load_breweries
  puts "Gettings names from CSV..."

  filepath = File.join(__dir__, '../data/amq.csv')
  csv_options = { col_sep: ',', headers: :first_row, header_converters: :symbol }

  amq_names = []

  CSV.foreach(filepath, col_sep: ',', headers: :first_row, header_converters: :symbol) do |row|
    cleaned = row[:name].gsub(/\s{2,}/, ' ').gsub(/\s-\s/, ' ').gsub(/[[:space]]/, '')
    titled = []

    first_words = %w[à la le ô]
    articles = %w[À La Le De Les Du Sur Et]

    cleaned.titleize.split.each_with_index do |str, index|
      if index.zero? && first_words.include?(str)
        titled << str.upcase
      elsif index.zero? && str.start_with?("L'")
        splitted = str.split("'")
        first = splitted.first
        last = splitted.last.capitalize
        titled << "#{first}'#{last}"
      elsif index.positive? && articles.include?(str)
        titled << str.downcase
      elsif str.start_with?("L'") || str.start_with?("D'")
        splitted = str.split("'")
        first = splitted.first.downcase
        last = splitted.last.capitalize
        titled << "#{first}'#{last}"
      else
        titled << str
      end
    end

    amq_names << titled.join(' ')
  end
  clean_list = amq_names.sort.uniq
  create_breweries(clean_list )
end
