# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'time'

Gem::Specification.new do |s|
  s.name        = 'darwinex'
  s.version     = '1.0.0'
  s.date        = Date.today.to_s
  s.summary     = 'Ruby client for the Darwinex API.'
  s.authors     = ['James Frost']
  s.email       = 'hello@jamesfrost.me'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.5.0'

  s.add_dependency 'httparty', '~> 0.18'

  s.add_development_dependency 'vcr', '~> 6.0'
  s.add_development_dependency 'webmock', '~> 3.8'
  s.add_development_dependency 'rspec', '~> 3.9'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']
end
