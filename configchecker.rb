# frozen_string_literal: true

class ConfigChecker
  def self.create_config_file
    File.open('config.json', 'w') do |f|
      f.write(default_config)
    end
  end

  def self.default_config
    {
      "server": {
        "ip": '0.0.0.0',
        "port": '4567'
      },
      "api_key":'API_KEY'
    }.to_json
  end
end

