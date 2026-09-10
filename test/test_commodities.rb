# frozen_string_literal: true

require 'bundler/setup'
require 'date'
require_relative '../lib/worldbank_as_dataframe'

FIXTURE = File.expand_path('../spec/fixtures/cmo_monthly_prices.xlsx', __dir__)
failures = []

failures << 'version' if WorldbankAsDataframe::VERSION.to_s.empty?

df = WorldbankAsDataframe::Commodities.new.fetch(path: FIXTURE)
failures << 'timestamps column' unless df.columns.include?('Timestamps')
failures << 'crude column' unless df.columns.include?('Crude oil, average ($/bbl)')
failures << '1960-01-01 row' unless df['Timestamps'].to_a.include?(Date.new(1960, 1, 1))
failures << 'crude value' unless df['Crude oil, average ($/bbl)'].to_a.first == 1.63

tagged = WorldbankAsDataframe::Commodities.new('CRUDE OIL').fetch(path: FIXTURE)
failures << 'tag columns' unless tagged.columns == ['Timestamps', 'Crude oil, average ($/bbl)']

windowed = WorldbankAsDataframe::Commodities.new.fetch(path: FIXTURE, start: '2020-01-01', fin: '2020-12-31')
failures << 'date window' unless windowed.height == 1 && windowed['Timestamps'].to_a == [Date.new(2020, 1, 1)]

c = WorldbankAsDataframe::Commodities.new
failures << 'normalize' unless c._normalize_key('<html>Monthly Prices*</html>') == 'monthly prices'

if failures.empty?
  puts 'test_commodities: ok'
else
  abort "test_commodities failed: #{failures.join(', ')}"
end
