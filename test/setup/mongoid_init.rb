require 'mongoid'

file_name = File.join(File.dirname(__FILE__), "mongoid.yml")
@settings = YAML.load(ERB.new(File.new(file_name).read).result)

Mongoid::Config.module_eval do 
  def logger
    nil
  end
end
Mongoid.configure do |config|
  config.from_hash(@settings)
end
