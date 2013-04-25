class Space
  include Virtus

  attribute :url
  attribute :name
  attribute :email

  def initialize(attributes, access_token)
    @access_token = access_token
    super attributes
  end

  def subdomain
    url.match(%r{https://([^\.]+)\.cobot\.me})[1]
  end

  def to_param
    subdomain
  end

  def self.find(space_id, access_token)
    begin
      new oauth(access_token).get("/api/spaces/#{space_id}").parsed, access_token
    rescue OAuth2::Error
      nil
    end
  end

  def memberships
    (oauth.get("#{url}/api/memberships").parsed || []).map do |attributes|
      Membership.new attributes
    end
  end

  def reminders
    Reminder.where(space_id: subdomain)
  end

  private

  def oauth
    self.class.oauth(@access_token)
  end

  def self.oauth(access_token)
    OAuth2::AccessToken.new(oauth_client, access_token)
  end

  def self.oauth_client
    @client ||= OAuth2::Client.new(nil, nil, site: 'https://www.cobot.me')
  end
end
