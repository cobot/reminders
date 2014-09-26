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
    url.match(%r{https?://([^\.]+)\.cobot\.me})[1]
  end

  def to_param
    subdomain
  end

  def self.find(space_id, access_token)
    begin
      new cobot_client(access_token).get('www', "/spaces/#{space_id}"), access_token
    rescue RestClient::ResourceNotFound
      nil
    end
  end

  def memberships
    begin
      (cobot_client.get(subdomain, "/memberships")).map do |attributes|
        Membership.new attributes
      end
    rescue RestClient::ResourceNotFound
      []
    end
  end

  def teams
    begin
      cobot_client.get(subdomain, "/teams")
    rescue RestClient::ResourceNotFound
      []
    end
  end

  def reminders
    Reminder.where(space_id: subdomain)
  end

  private

  def cobot_client
    self.class.cobot_client(@access_token)
  end

  def self.cobot_client(access_token)
    CobotClient::ApiClient.new access_token
  end
end
