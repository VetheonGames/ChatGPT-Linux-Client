class Config
  attr_reader :config

  def initialize
    @config = JSON.parse(File.read('config.json'))
  end

  def server_ip
    config['server']['ip']
  end

  def server_port
    config['server']['port']
  end
end
