# frozen_string_literal: true

class Config
  attr_reader :config, :api_key, :server_ip, :server_port

  def initialize
    @config = JSON.parse(File.read('config.json'))
    @server_ip = @config['server']['ip']
    @server_port = @config['server']['port']
    @api_key = @config['api_key']
  rescue Errno::ENOENT => e
    puts "Error: config.json file not found, please check that the file exists in the current directory: #{e.class}"
    exit
  rescue JSON::ParserError => e
    puts "Error: config.json file is not valid JSON, please check the format of the file: #{e.class}"
    exit
  end
end
