# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kuroneko/version'

Gem::Specification.new do |spec|
  spec.name          = "kuroneko"
  spec.version       = Kuroneko::VERSION
  spec.authors       = ["wktk"]
  spec.email         = ["wktk30@gmail.com"]
  spec.description   = %q{クロネコヤマトの荷物追跡を照会する}
  spec.summary       = spec.description
  spec.homepage      = "https://github.com/wktk/kuroneko"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "mechanize", "~> 2.7"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
