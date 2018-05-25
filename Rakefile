# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc 'Generates data json files from tzinfo-data gem tagged versions from github'
task 'generate-data' do
  require 'a0/tzmigration/data_generator'

  A0::TZMigration::DataGenerator.new('data').generate
end
