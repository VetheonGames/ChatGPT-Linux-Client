# frozen_string_literal: true

require 'net/http'
require 'json'
require 'optparse'
require_relative 'configmanager'

config = Config.new
options = {}
@opt_parser = OptionParser.new do |opt|
  opt.on('-q QUERY', '--query QUERY', 'The query to be sent') do |query|
    options[:query] = query
  end

  opt.on('-h', '--help', 'help') do
    puts @opt_parser
    exit
  end
end

@opt_parser.parse!

if options[:query].nil?
  puts 'No query provided. Please provide a query with the -q or --query option'
  exit
end

# Send GET request to server with query and api_key as parameters
uri = URI("http://#{config.server_ip}:#{config.server_port}/query?query=#{options[:query]}&api_key=#{config.api_key}")

begin
  response = Net::HTTP.get(uri)
rescue
  puts 'Error: Unable to reach the server, please check the IP and port of the server in the config.json file'
  exit
end

# Print the response
puts response
