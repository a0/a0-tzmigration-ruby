# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'a0/tzmigration/version'

Gem::Specification.new do |spec|
  spec.name          = 'a0-tzmigration-ruby'
  spec.version       = A0::TZMigration::VERSION
  spec.authors       = ['Aldrin Martoq']
  spec.email         = ['contacto@a0.cl']

  spec.summary       = 'Time zone migration utilities, for ruby'
  spec.description   = 'A gem that helps migration between timezone changes when they happen in the tzdata/zoneinfo/Olson database.'
  spec.homepage      = 'http://github.com/a0/a0-tzmigration-ruby'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|data)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'

  spec.add_development_dependency 'fasten'
  spec.add_development_dependency 'git'
  spec.add_development_dependency 'ruby-progressbar'
  spec.add_development_dependency 'tzinfo'

  spec.add_dependency 'rest-client'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.' unless spec.respond_to?(:metadata)

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
end
