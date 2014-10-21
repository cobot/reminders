require 'spec_helper'

describe Address, '#first_name' do
  it 'returns the first word of the name' do
    expect(Address.new(name: 'joe doe').first_name).to eql('joe')
  end
end

describe Address, '#attributes' do
  it 'includes first_name' do
    expect(Address.new(name: 'joe doe').attributes).to eql(
      name: "joe doe",
      company: nil,
      address: nil,
      city: nil,
      contry: nil,
      state: nil,
      post_code: nil,
      first_name: 'joe'
    )
  end
end
