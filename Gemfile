source 'https://rubygems.org'

# Specify your gem's dependencies in atpay-button-generator.gemspec
gemspec

gem 'liquid'
gem 'atpay_tokens'
gem 'activesupport', '4.0.0'
gem 'trollop'

# Test-specific gems
group :test do
  gem 'capybara', '~> 1.1.0'
end

group :development, :test do
  gem 'pry'
  gem 'minitest', '> 3.1.0'
  gem 'minitest-reporters', '>= 0.5.0', :github => "atpay/minitest-reporters", :require => false
  gem 'simplecov'
  gem 'mocha'
end
