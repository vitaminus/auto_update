# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'auto_update/version'

Gem::Specification.new do |spec|
  spec.name          = "auto_update"
  spec.version       = AutoUpdate::VERSION
  spec.authors       = ["vitaminus"]
  spec.email         = ["vitaliy.t@rewardexpert.com"]

  spec.summary       = "Rewardexpert auto update"
  spec.description   = "Rewardexpert auto update programs gem"
  spec.homepage      = "https://www.rewardexpert.com"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://mygemserver.com'
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'capybara', '2.7.1'
  spec.add_development_dependency 'capybara-screenshot', '1.0.10'
  spec.add_development_dependency 'poltergeist', '1.9.0'
  spec.add_development_dependency 'selenium-webdriver', "~> 2.0"
end
