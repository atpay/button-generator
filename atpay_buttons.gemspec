# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "atpay_buttons"
  spec.version       = '1.4.4'
  spec.date          = '2014-04-07'
  spec.authors       = ["Thomas Pastinsky", "Glen Holcomb", "James Kassemi", "Isaiah Baca"]
  spec.email         = ["dev@atpay.com", "james@atpay.com"]
  spec.description   = 'Atpay button generator'
  spec.summary       = 'Command line tool and Ruby library for generating @Pay 2 click email buttons'
  spec.homepage      = "http://atpay.com"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "atpay_tokens"
  spec.add_runtime_dependency "liquid"
end
