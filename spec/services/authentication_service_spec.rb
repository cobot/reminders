require 'spec_helper'

describe AuthenticationService, '#call' do
  before(:each) do
    @service = AuthenticationService.new
    @auth = stub(:auth, uid: '1').as_null_object
    User.stub(:create!)
  end

  it 'creates a user if it does not exist yet' do
    User.stub(:where).with(cobot_id: '1') {[]}

    User.should_receive(:create!)

    @service.call(@auth)
  end

  it 'returns an existing user' do
    user = stub(:user)
    User.stub(:where).with(cobot_id: '1') {[user]}

    expect(@service.call(@auth)).to eql(user)
  end
end
