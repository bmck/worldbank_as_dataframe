require 'helper'

describe WorldBank::Client do

  context 'get' do
    let(:query_string) { 'sources/all?format=json' }
    let(:client) { WorldBank::Client.new( { :dirs => ['sources', 'all'], :params => {:format => 'json'}}, false) }
    
    it 'returns the response from the specified path' do
      stub_get(query_string).to_return(:status => 200, :body => fixture('sources.json'))
      
      client.get(query_string)
      
      a_get(query_string).should have_been_made
    end
    
    it "returns null if status is not in 200s" do
      stub_get(query_string).to_return(:status => 500)
      client.get(query_string).should be_nil
    end
  end

end
