# frozen_string_literal: true

def expect_eq_not_nil(value_a, value_b)
  expect(value_a).to eq(value_b)
  expect(value_a).not_to be nil
  expect(value_b).not_to be nil
end

RSpec.describe A0::TZMigration do
  it 'can run the data generator' do
    # A0::TZMigration::DataGenerator.new('data').generate
  end

  it 'has a version number' do
    expect(A0::TZMigration::VERSION).not_to be nil
    expect(A0::TZMigration::VERSION).to eq('0.1.1')
  end

  it 'can load version index' do
    versions = A0::TZMigration::TZVersion.versions
    expect(versions.keys).to include('2013c', '2018e')
    expect(versions['2013c']['timezones']).to include('America/Santiago', 'Zulu')
  end

  it 'can load timezone index' do
    timezones = A0::TZMigration::TZVersion.timezones
    expect(timezones.keys).to include('America/Santiago', 'Zulu')
    expect(timezones['America/Santiago']['versions']).to include('2018c', '2018e')
  end

  it 'can get a tzversion release date' do
    tzversion = A0::TZMigration::TZVersion.new('America/Santiago', '2018e')
    released_at = tzversion.released_at
    expect(released_at).to eq('2018-05-01 23:42:51 -0700')
  end

  it 'can load an aliased tzversion and has the same data that the target timezone version' do
    tzversion_a = A0::TZMigration::TZVersion.new('America/Santiago', '2018e')
    tzversion_b = A0::TZMigration::TZVersion.new('Chile/Continental', '2018e')
    version_data_a = tzversion_a.version_data
    version_data_b = tzversion_b.version_data
    expect_eq_not_nil(version_data_a, version_data_b)
  end

  it 'throws error when loading an unknown version' do
    expect do
      tzversion_a = A0::TZMigration::TZVersion.new('America/Santiago', '1800a')
      tzversion_a.version_data
    end.to raise_error('Version 1800a not found for America/Santiago.')
  end

  it 'throws error when loading an unknown timezone' do
    expect do
      tzversion_a = A0::TZMigration::TZVersion.new('America/Santiagors', '2018e')
      tzversion_a.version_data
    end.to raise_error(RuntimeError)
  end

  it 'returns no changes for America/Santiago from version 2014i to 2014j' do
    tzversion_a = A0::TZMigration::TZVersion.new('America/Santiago', '2014i')
    tzversion_b = A0::TZMigration::TZVersion.new('America/Santiago', '2014j')
    changes = tzversion_a.changes(tzversion_b)
    expect(changes).to eq([])
  end

  it 'returns non empty changes for America/Santiago from version 2014i to 2015a' do
    tzversion_a = A0::TZMigration::TZVersion.new('America/Santiago', '2014i')
    tzversion_b = A0::TZMigration::TZVersion.new('America/Santiago', '2015a')
    changes = tzversion_a.changes(tzversion_b)
    expect(changes.length).not_to eq(0)
  end

  it 'returns the expected changes for America/Caracas from version 2016c to 2016d' do
    tzversion_a = A0::TZMigration::TZVersion.new('America/Caracas', '2016c')
    tzversion_b = A0::TZMigration::TZVersion.new('America/Caracas', '2016d')
    changes = tzversion_a.changes(tzversion_b)
    first = changes.first

    expect(changes.length).to eq(1)
    expect(first[:off]).to eq(1800)
    expect(first[:ini]).to eq(Time.parse('2016-05-01T02:30:00-04:30').to_i)
    expect(first[:fin]).to eq(Float::INFINITY)
    expect(first[:ini_str]).to eq('2016-05-01 07:00:00 UTC')
    expect(first[:fin_str]).to eq('∞')
    expect(first[:off_str]).to eq('+00:30:00')
  end

  def compare_inverse(zone_a, version_a, zone_b, version_b) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    a = A0::TZMigration::TZVersion.new(zone_a, version_a)
    b = A0::TZMigration::TZVersion.new(zone_b, version_b)
    dab = a.changes(b)
    dba = b.changes(a)

    expect(dab.count).to eq(dba.count)

    dab.each_with_index do |_item, index|
      item_a = dab[index]
      item_b = dba[index]

      expect_eq_not_nil(item_a[:ini], item_b[:ini])
      expect_eq_not_nil(item_a[:fin], item_b[:fin])
      expect_eq_not_nil(item_a[:off], -item_b[:off])
      expect_eq_not_nil(item_a[:ini_str], item_b[:ini_str])
      expect_eq_not_nil(item_a[:fin_str], item_b[:fin_str])
    end
  end

  versions = %w[2013c 2015a 2016a 2018e]
  versions.product(versions).each do |version_a, version_b|
    it "returns the inverse changes America/Santiago from version #{version_a} to #{version_b}" do
      compare_inverse('America/Santiago', version_a, 'America/Santiago', version_b)
    end
  end

  it 'config base_url works as expected' do
    A0::TZMigration.configure do |config|
      config.base_url = 'http://foo'
    end
    expect do
      tz_version = A0::TZMigration::TZVersion.new('America/Santiagors', '2018e')
      tz_version.version_data
    end.to raise_error(RuntimeError)
    A0::TZMigration.configure do |config|
      config.base_url = 'https://a0.github.io/a0-tzmigration-ruby/data/'
    end
    expect do
      tz_version = A0::TZMigration::TZVersion.new('America/Santiagors', '2018e')
      tz_version.version_data
    end.to raise_error(RuntimeError)
    tz_version = A0::TZMigration::TZVersion.new('America/Santiago', '2018e')
    tz_version.version_data
  end
end
