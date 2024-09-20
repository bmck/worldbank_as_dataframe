require 'helper'

describe WorldbankAsDataframe::Indicator do
  context 'find' do
    it 'returns a WorldbankAsDataframe::Indicator' do
      stub_get('indicators/AG.AGR.TRAC.NO?format=json').
        to_return(:status => 200, :body => fixture('indicators_tractors.json'))
      tractors = WorldbankAsDataframe::Indicator.find('AG.AGR.TRAC.NO').fetch
      a_get('indicators/AG.AGR.TRAC.NO?format=json').should have_been_made
      tractors.should be_a WorldbankAsDataframe::Indicator
    end
    context 'returned Indicator has' do
      before do
        stub_get('indicators/AG.AGR.TRAC.NO?format=json').
          to_return(:status => 200, :body => fixture('indicators_tractors.json'))
        @tractors = WorldbankAsDataframe::Indicator.find('AG.AGR.TRAC.NO').fetch
      end
      it 'an id' do
        @tractors.id.should eql 'AG.AGR.TRAC.NO'
      end
      it 'a name' do
        @tractors.name.should eql 'Agricultural machinery, tractors'
      end
      it 'a source' do
        @tractors.source.should be_a WorldbankAsDataframe::Source
      end
      it 'a note' do
        @tractors.note[0..19].should eql 'Agricultural machine'
      end
      it 'an organization' do
        @tractors.organization.should eql 'Food and Agriculture Organization, electronic files and web site.'
      end
      it 'many topics' do
        @tractors.topics[0].should be_a WorldbankAsDataframe::Topic
      end
    end
  end
end
