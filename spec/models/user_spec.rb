require 'spec_helper'

describe User, '#spaces' do
  it 'passes the space url to the space' do
    user = User.new do |u|
      u.access_token = '123'
      u.admin_of = [
        {"space_link" => "https://www.cobot.me/api/spaces/some-space"}
      ]
    end

    expect(Space).to receive(:new).with({url: 'https://some-space.cobot.me'}, '123')

    user.spaces
  end
end
