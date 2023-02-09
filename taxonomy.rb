require 'httparty'

genus = ARGV[0]
species = ARGV[1]

begin
  url = "https://services.itis.gov/?q=nameWOInd:#{genus}%5c #{species}"
  response = HTTParty.get(url)
  parsed = response.dig('response', 'docs')[0]
  if parsed.nil?
    puts("No match found for #{genus} #{species}")
    exit
  end
  vernaculars = response.dig('response', 'docs')[0].dig('vernacular')

  puts("Common names for #{genus} #{species}:")
  vernaculars.each_with_index do |vernacular, index|
    phrase = vernacular.split('$')[1]
    language = vernacular.split('$')[2]
    puts("\t#{index + 1}. #{phrase} // #{language}")
  end
rescue
  puts("Error reaching ITIS, try again!")
end
