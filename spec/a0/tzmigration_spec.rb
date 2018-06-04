# frozen_string_literal: true

RSpec.describe A0::TZMigration do
  it 'has a version number' do
    expect(A0::TZMigration::VERSION).not_to be nil
    expect(A0::TZMigration::VERSION).to eq('1.0.2')
  end
end
