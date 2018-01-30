require 'spec_helper'

describe AuthenticationService, '#call' do
  before(:each) do
    @service = AuthenticationService.new
    @auth = double(:auth, uid: '1').as_null_object
    allow(User).to receive(:create!)
  end

  it 'creates a user if it does not exist yet' do
    allow(User).to receive(:where).with(cobot_id: '1') {[]}

    expect(User).to receive(:create!)

    @service.call(@auth)
  end

  it 'returns an existing user' do
    user = double(:user)
    allow(User).to receive(:where).with(cobot_id: '1') {[user]}

    expect(@service.call(@auth)).to eql(user)
  end
end
