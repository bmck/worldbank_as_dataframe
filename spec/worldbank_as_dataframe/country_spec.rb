require 'helper'

describe WorldbankAsDataframe::Country do
  context 'returned Country has' do
    before do
      stub_get('countries/in?format=json').
        to_return(:status => 200, :body => fixture('countries_india.json'))
      @india = WorldbankAsDataframe::Country.find('in').fetch
    end
    it 'a three letter code' do
      @india.iso3_code.should eql 'IND'
    end
    it 'a two letter code' do
      @india.iso2_code.should eql 'IN'
    end
    it 'a name' do
      @india.name.should eql 'India'
    end
    it 'an IncomeLevel' do
      @india.income_level.should be_a WorldbankAsDataframe::IncomeLevel
    end
    it 'a LendingType' do
      @india.lending_type.should be_a WorldbankAsDataframe::LendingType
    end
    it 'a capital' do
      @india.capital.should eql 'New Delhi'
    end
    it 'a region' do
      @india.region.should be_a WorldbankAsDataframe::Region
    end
    it 'should initialize without all required attributes' do
      WorldbankAsDataframe::Country.new({'name' => 'France'}).should be_an_instance_of(WorldbankAsDataframe::Country)
    end
  end
end
