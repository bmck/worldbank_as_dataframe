require 'helper'

describe WorldbankAsDataframe::Commodities do
  let(:fixture) { File.expand_path('../../fixtures/cmo_monthly_prices.xlsx', __FILE__) }

  it 'is instantiable' do
    WorldbankAsDataframe::Commodities.new.should be_a WorldbankAsDataframe::Commodities
  end

  it 'parses Monthly Prices from a chart-heavy workbook via Roo' do
    df = WorldbankAsDataframe::Commodities.new.fetch(path: fixture)
    df.columns.should include('Timestamps')
    df.columns.should include('Crude oil, average ($/bbl)')
    df['Timestamps'].to_a.should include(Date.new(1960, 1, 1))
    df['Crude oil, average ($/bbl)'].to_a.first.should == 1.63
  end

  it 'treats ellipsis cells as null and matches series tags case-insensitively' do
    df = WorldbankAsDataframe::Commodities.new('crude oil').fetch(path: fixture)
    df.columns.should == ['Timestamps', 'Crude oil, average ($/bbl)']
    df.filter(Polars.col('Timestamps') == Date.new(1960, 2, 1))['Crude oil, average ($/bbl)'].to_a.first.should be_nil
  end

  it 'filters by start and fin' do
    df = WorldbankAsDataframe::Commodities.new.fetch(path: fixture, start: '2020-01-01', fin: '2020-12-31')
    df.height.should == 1
    df['Timestamps'].to_a.should == [Date.new(2020, 1, 1)]
  end
end
