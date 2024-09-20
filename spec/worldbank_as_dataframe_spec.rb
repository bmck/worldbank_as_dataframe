require 'helper'

describe WorldbankAsDataframe do
  context 'client' do
    it "is an instance of WorldbankAsDataframe::Client" do
      WorldbankAsDataframe.client.should be_a WorldbankAsDataframe::Client
    end
  end
end
