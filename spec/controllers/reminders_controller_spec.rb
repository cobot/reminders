require 'spec_helper'

describe RemindersController do
  it 'requires authentication' do
    get :index, space_id: '1'

    expect(response).to redirect_to('/auth/cobot')
  end

  it 'works when authenticated' do
    User.stub(:find).with(1) {stub(:user, spaces: [stub(:space, to_param: '1', reminders: [stub])])}
    session[:user_id] = 1

    get :index, space_id: '1'

    expect(response).to be_success
  end
end
