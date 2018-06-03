# frozen_string_literal: true

RSpec.describe A0::TZMigration::Util do
  Util = A0::TZMigration::Util

  it 'offset_to_str' do
    expect(Util.offset_to_str(0)).to eq('+00:00:00')
    expect(Util.offset_to_str(-1)).to eq('-00:00:01')
    expect(Util.offset_to_str(-3600)).to eq('-01:00:00')
    expect(Util.offset_to_str(-16_200)).to eq('-04:30:00')
  end

  it 'timestamp_to_str' do
    expect(Util.timestamp_to_str(0)).to eq('1970-01-01 00:00:00 UTC')
    expect(Util.timestamp_to_str(-1_893_439_034)).to eq('1910-01-01 04:42:46 UTC')
    expect(Util.timestamp_to_str(637_729_200)).to eq('1990-03-18 03:00:00 UTC')
    expect(Util.timestamp_to_str(-Float::INFINITY)).to eq('-∞')
    expect(Util.timestamp_to_str(Float::INFINITY)).to eq('∞')
  end

  it 'range_item' do
    expected = { ini_str: '1946-07-15 04:00:00 UTC', fin_str: '1947-04-01 04:00:00 UTC', off_str: '+01:00:00', ini: -740_520_000, fin: -718_056_000, off: 3600 }
    expect(Util.range_item(-740_520_000, -718_056_000, 3600)).to eq(expected)
  end
end
