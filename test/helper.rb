require 'rubygems'
require 'bundler'
require 'erb'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'setup'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'minitest/autorun'
require 'minitest/spec'
require 'mongoid-cached-references'
require 'mongoid_init'
class Text;end
require 'directory'
require 'text'
require 'factories'
