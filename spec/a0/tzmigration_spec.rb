# frozen_string_literal: true

RSpec.describe A0::TZMigration do
  it 'has a version number' do
    expect(A0::TZMigration::VERSION).not_to be nil
  end

  it 'can run the data generator' do
    A0::TZMigration::DataGenerator.new('data').generate
  end

  it 'can load a timezone version' do
    A0::TZMigration::TZVersion.new('America/Santiago', '2018e')
  end

  it 'can load an alias timezone version and has the same data that the target timezone version' do
    a = A0::TZMigration::TZVersion.new('America/Santiago', '2018e')
    b = A0::TZMigration::TZVersion.new('Chile/Continental', '2018e')
    expect(a.timezone_ranges).to eq(b.timezone_ranges)
  end

  it 'can run the delta range calculation' do
    a = A0::TZMigration::TZVersion.new('America/Santiago', '2014i')
    b = A0::TZMigration::TZVersion.new('America/Santiago', '2014j')
    a.delta_range_list(b)
  end

  it 'returns an empty list for America/Santiago between 2014i 2014j versions' do
    a = A0::TZMigration::TZVersion.new('America/Santiago', '2014i')
    b = A0::TZMigration::TZVersion.new('America/Santiago', '2014j')
    d = a.delta_range_list(b)
    expect(d).to eq([])
  end

  it 'returns a non empty list for America/Santiago between 2014i 2015a versions' do
    a = A0::TZMigration::TZVersion.new('America/Santiago', '2014i')
    b = A0::TZMigration::TZVersion.new('America/Santiago', '2015a')
    d = a.delta_range_list(b)
    size_check = d.count > 0
    expect(size_check).to eq(true)
  end

  it 'returns the delta range expected for America/Caracas' do
    a = A0::TZMigration::TZVersion.new('America/Caracas', '2016c')
    b = A0::TZMigration::TZVersion.new('America/Caracas', '2016d')
    d = a.delta_range_list(b)
    count = d.count
    first = d.first

    expect(count).to eq(1)
    expect(first[:off]).to eq(1800)
    expect(first[:utc_ini]).to eq(Time.parse('2016-05-01T02:30:00-04:30'))
  end

  it 'returns the inverse delta range list for America/Santiago between 2013c 2018e versions' do
    a = A0::TZMigration::TZVersion.new('America/Santiago', '2013c')
    b = A0::TZMigration::TZVersion.new('America/Santiago', '2015a')
    dab = a.delta_range_list(b)
    dba = b.delta_range_list(a)

    expect(dab.count).to eq(dba.count)

    dab.each_with_index do |_item, index|
      item_a = dab[index]
      item_b = dba[index]

      expect(item_a[:ini]).to eq(item_b[:ini])
      expect(item_a[:fin]).to eq(item_b[:fin])
      expect(item_a[:off]).to eq(-item_b[:off])
      expect(item_a[:utc_ini]).to eq(item_b[:utc_ini])
      expect(item_a[:utc_fin]).to eq(item_b[:utc_fin])
    end
  end
end
