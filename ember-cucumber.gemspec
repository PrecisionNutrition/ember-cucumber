# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ember/cucumber/version'

Gem::Specification.new do |spec|
  spec.name          = "ember-cucumber"
  spec.version       = Ember::Cucumber::VERSION
  spec.authors       = ["Alaina Hardie"]
  spec.email         = ["alaina@precisionnutrition.com"]
  spec.description   = 'Add steps to support testing Ember apps with Cucumber'
  spec.summary       = 'Add steps to support testing Ember apps with Cucumber'
  spec.homepage      = "https://github.com/PrecisionNutrition/ember-cucumber"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "cucumber", "~> 1.3.10"
  spec.add_dependency "spreewald", "~> 0.8.6"
end
