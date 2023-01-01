# frozen_string_literal: true

# Proof of concept for an API generic API shim module
# Suggested command line usage: ruby api_shim.rb && open result.html
module APIShim
  # Shim client instance that will act as our interfact to the API
  class Client
    require 'httparty'
    include HTTParty
    base_uri 'https://www.google.com'

    # Constants
    # Add to this as you build out your interactions
    SEARCH_QUERY_PATH = '/search'

    # Make a search request to Google with the given query
    #
    # @param query [String] the search query
    # @return [Hash] the parsed API response
    def search(query)
      begin
        api_response = self.class.get(SEARCH_QUERY_PATH, query: { q: query })
      rescue StandardError => e
        puts 'Error calling target API'
        verbose_error = "#{e.backtrace}: #{e.message} (#{e.class})"
        puts verbose_error
      end

      # Return the parsed response
      api_response.parsed_response
    end
  end
end

# Example usage:
client = APIShim::Client.new
results = client.search("Matz is nice so we are nice")

# Create a new file and write the results to it
File.open("result.html", "w") do |file|
  file.write(results)
end

