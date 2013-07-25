# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "atpay_buttons"
  spec.version       = '0.1'
  spec.authors       = ["Thomas Pastinsky"]
  spec.email         = ["tom@atpay.com"]
  spec.description   = %q{Atpay button generator}
  spec.summary       = %q{Atpay button generator summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "atpay_tokens"
  spec.add_dependency "liquid"

end
