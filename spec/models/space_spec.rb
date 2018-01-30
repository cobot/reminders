require 'spec_helper'

describe Space, '#subdomain' do
  it 'parses the subdomain from the url' do
    space = Space.new({url: 'https://co-up.cobot.me'}, '')

    expect(space.subdomain).to eql('co-up')
  end

  it 'parses the subdomain from a http url' do
    space = Space.new({url: 'http://co-up.cobot.me'}, '')

    expect(space.subdomain).to eql('co-up')
  end
end

describe Space, '#memberships' do
  it 'returns an empty array if the api call returns 404' do
    client = double(:client)
    allow(CobotClient::ApiClient).to receive_messages(new: client)
    allow(client).to receive(:get).and_raise(RestClient::ResourceNotFound)

    expect(Space.new({url: 'https://co-up.cobot.me'}, '').memberships).to eql([])
  end
end
