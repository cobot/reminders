require 'spec_helper'

describe Space, '#subdomain' do
  it 'parses the subdomain from the url' do
    space = Space.new({url: 'https://co-up.cobot.me'}, '')

    expect(space.subdomain).to eql('co-up')
  end
end

describe Space, '#memberships' do
  it 'returns an em[ty array if the api call returns 404' do
    OAuth2::AccessToken.stub(new: stub(:token, get: stub(:response, parsed: nil)))

    expect(Space.new({}, '').memberships).to eql([])
  end
end
