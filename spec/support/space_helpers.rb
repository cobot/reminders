module SpaceHelpers
  def stub_space(id)
    subdomain = id.sub('space-', '')

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
