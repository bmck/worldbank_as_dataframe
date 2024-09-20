require 'helper'

describe WorldbankAsDataframe::Region do
  context 'find' do
    it 'returns WorldbankAsDataframe::Region' do
      stub_get('regions/wld?format=json').
        to_return(:status => 200, :body => fixture('regions_world.json'))
      @so_helpful = WorldbankAsDataframe::Region.find('wld').fetch
      a_get('regions/wld?format=json').should have_been_made
      @so_helpful.should be_a WorldbankAsDataframe::Region
    end
    context 'returned Region has' do
      before do
        stub_get('regions/wld?format=json').
          to_return(:status => 200, :body => fixture('regions_world.json'))
        @so_helpful = WorldbankAsDataframe::Region.find('wld').fetch
      end
      it 'an id' do
        @so_helpful.id.should eql ''
      end
      it 'a code' do
        @so_helpful.code.should eql 'WLD'
      end
      it 'a name' do
        @so_helpful.name.should eql 'World'
      end
    end
  end
end
