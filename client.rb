# frozen_string_literal: true

require 'net/http'
require 'json'
require 'optparse'
require_relative 'configmanager'
require_relative 'configchecker'

class Client
  def initialize
    ConfigChecker.create_config_file unless File.file?('config.json')
    @config = Config.new
    @options = {}
    @opt_parser = OptionParser.new do |opt|
      opt.on('-q QUERY', '--query QUERY', 'The query to be sent') do |query|
        @options[:query] = query
      end

      opt.on('-h', '--help', 'help') do
        puts @opt_parser
        exit
      end
    end
  end

  def run
    @opt_parser.parse!

    if @options[:query].nil?
      puts 'No query provided. Please provide a query with the -q or --query option'
      exit
    end

    uri = URI("http://#{@config.server_ip}:#{@config.server_port}/query?query=#{@options[:query]}&api_key=#{@config.api_key}")
    response = send_request(uri)
    handle_response(response)
  end

  private

  def send_request(uri)
    begin
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri)
      request['Content-Type'] = 'application/json'
      response = http.request(request)
    rescue Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,
           Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError => e
      puts "Error: Unable to reach the server, please check the IP and
            port of the server in the config.json file: #{e.class}"
      exit
    end
    response.body
  end

  def handle_response(response)
    begin
      json_response = JSON.parse(response)
    rescue JSON::ParserError
      puts 'Error: Server returned a non-JSON response'
      exit
    end

    if json_response['status'] == 'error'
      puts "Error: #{json_response['message']}"
      exit
    end

    puts json_response['data']
  end
end
