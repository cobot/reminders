require 'spec_helper'

describe RemindersController do
  it 'requires authentication' do
    get :index, space_id: '1'

    expect(response).to redirect_to('/auth/cobot')
  end

  it 'works when authenticated' do
    log_in stub(:user, spaces: [stub(:space, to_param: '1', reminders: [stub])])

    get :index, space_id: '1'

    expect(response).to be_success
  end
end

describe RemindersController, '#create' do
  it 'sets the access token' do
    reminder = stub(:reminder).as_null_object
    space = stub(:space, to_param: 'co-up')
    space.stub_chain(:reminders, :build) {reminder}
    user = stub(:user, access_token: '123', spaces: [space])
    log_in user

    reminder.should_receive(:access_token=).with('123')

    post :create, reminder: {}, space_id: 'co-up'
  end
end
