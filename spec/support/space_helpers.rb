module SpaceHelpers
  def stub_space(id)
    subdomain = id.sub('space-', '')
    WebMock.stub_request(:get, 'https://www.cobot.me/api/user').to_return(body: {
      id: 'user-alex',
      memberships: [],
      admin_of: [
        {
          space_link: "https://www.cobot.me/api/spaces/#{subdomain}",
          name: 'joe'
        }
      ],
      email: 'joe@cobot.me'
    }.to_json, headers: {'Content-Type' => 'application/json'})

    WebMock.stub_request(:get, "https://www.cobot.me/api/spaces/#{id}").to_return(body: {
      name: subdomain.capitalize,
      url: "https://#{subdomain}.cobot.me",
      id: id
    }.to_json, headers: {'Content-Type' => 'application/json'})
  end
end

RSpec.configure do |c|
  c.send :include, SpaceHelpers
end
