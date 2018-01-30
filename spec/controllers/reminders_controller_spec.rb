require 'spec_helper'

describe RemindersController do
  it 'requires authentication' do
    get :index, space_id: '1'

    expect(response).to redirect_to('/auth/cobot')
  end

  it 'works when authenticated' do
    log_in double(:user, spaces: [double(:space, to_param: '1', reminders: [double])])

    get :index, space_id: '1'

    expect(response).to be_success
  end
end

describe RemindersController, '#create' do
  it 'sets the access token' do
    reminder = double(:reminder).as_null_object
    space = double(:space, to_param: 'co-up')
    allow(space).to receive_message_chain(:reminders, :build) {reminder}
    user = double(:user, access_token: '123', spaces: [space])
    log_in user

    expect(reminder).to receive(:access_token=).with('123')

    post :create, reminder: {}, space_id: 'co-up'
  end
end
