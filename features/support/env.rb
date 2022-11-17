require 'parallel_tests'
require 'cucumber'
require 'rake'
require 'rspec'
require 'selenium-webdriver'
require 'capybara/cucumber'
require 'pry'
require 'faker'
require 'cuke_modeler'
require 'webdrivers'

#require 'clipboard'

Dir[File.join(File.dirname(__FILE__), 'core/**/*.rb')].sort.each { |file| require_relative file }
Dir[File.join(File.dirname(__FILE__), 'api/**/*.rb')].sort.each { |file| require_relative file }
Dir[File.join(File.dirname(__FILE__), 'api/**/**/*.rb')].sort.each { |file| require_relative file }

require_relative 'bridge.rb'

HEADLESS = ENV['HEADLESS'].nil? ? false : true
WEB = ENV['WEB'].nil? ? false : true
PLATFORM = ENV['PLATFORM']
BROWSER = ENV['BROWSER']
FIREFOX = ENV['FIREFOX'].nil? ? false : true
CHROME = ENV['CHROME'].nil? ? false : true
PARALLEL = ENV['PARALLEL']
ENVIRONMENT = ENV['ENVIRONMENT']
MAIN_URL = ENV['MAIN_URL']
CUCUMBER_PUBLISH_QUIET = true