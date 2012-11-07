class Space
  include Virtus

  attribute :url
  attribute :name

  def initialize(attributes, access_token)
    @access_token = access_token
    super attributes
  end

  def self.find(space_id, access_token)
    new oauth(access_token).get("/api/spaces/#{space_id}").parsed, access_token
  end

  def memberships
    oauth.get("#{url}/api/memberships").parsed.map do |attributes|
      Membership.new attributes, @access_token
    end
  end

  private

  def oauth
    self.class.oauth(@access_token)
  end

  def self.oauth(access_token)
    @oauth ||= OAuth2::AccessToken.new(oauth_client, access_token)
  end

  def self.oauth_client
    @client ||= OAuth2::Client.new(nil, nil, site: 'https://www.cobot.me')
  end


end
