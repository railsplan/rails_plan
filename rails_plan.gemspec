# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_plan/version'

Gem::Specification.new do |spec|
  spec.name          = 'rails_plan'
  spec.authors       = ['Paweł Dąbrowski']
  spec.email         = ['contact@paweldabrowski.com']
  spec.license       = 'MIT'
  spec.version       = RailsPlan::VERSION.dup
  spec.summary       = 'Speed up Rails app planning and development process'
  spec.description   = spec.summary
  spec.homepage      = 'https://railsplan.com'
  spec.files         = Dir['README.md', 'railsplan.gemspec', 'bin/*', 'lib/**/*']
  spec.bindir        = 'bin'
  spec.executables   = ['rplan']
  spec.require_paths = ['lib']

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.add_runtime_dependency 'rest-client', '2.1.0'

  spec.required_ruby_version = '>= 3.2.2'
end
