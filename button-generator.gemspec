# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'button/generator/version'

Gem::Specification.new do |spec|
  spec.name          = "button-generator"
  spec.version       = Button::Generator::VERSION
  spec.authors       = ["Thomas Pastinsky", "Isaiah Baca"]
  spec.email         = ["tom@atpay.com", "isaiah@atpay.com"]
  spec.description   = %q{Create buttons for use with the @Pay API from your own system}
  spec.summary       = %q{A button generator library which interfaces with the @Pay API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
