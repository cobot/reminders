require 'spec_helper'

describe Space, '#subdomain' do
  it 'parses the subdomain from the url' do
    space = Space.new({url: 'https://co-up.cobot.me'}, '')

    expect(space.subdomain).to eql('co-up')
  end
end
