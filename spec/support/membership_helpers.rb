module MembershipHelpers
  def stub_memberships(space_id, memberships)
    subdomain = space_id.sub('space-', '')
    WebMock.stub_request(:get, "https://#{subdomain}.cobot.me/api/memberships"
      ).to_return(body: memberships.to_json, headers: {'Content-Type' => 'application/json'})
  end
end

RSpec.configure do |c|
  c.send :include, MembershipHelpers
end
