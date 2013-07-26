require 'simplecov'
SimpleCov.start

require 'pry'
require File.dirname(__FILE__) + '/../lib/atpay_buttons'

# require 'minitest'
require 'minitest/autorun'

require 'mocha/setup'

# See http://www.jetbrains.com/ruby/webhelp/minitest.html
if ENV["RM_INFO"] || ENV["TEAMCITY_VERSION"]
  require 'active_support'
  require 'minitest/reporters'
  MiniTest::Reporters.use! MiniTest::Reporters::RubyMineReporter.new
end

