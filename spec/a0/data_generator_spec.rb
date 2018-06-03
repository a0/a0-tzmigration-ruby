# frozen_string_literal: true

require 'a0/tzmigration/data_generator'

RSpec.describe A0::TZMigration::DataGenerator do
  it 'can run the data generator' do
    A0::TZMigration::DataGenerator.new('data').generate
  end
end
