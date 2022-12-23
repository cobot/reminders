class User < ApplicationRecord
  serialize :admin_of

  def spaces
    admin_of.map do |admin|
      subdomain = admin['space_link'].split('/').last
      Space.new({url: "https://#{subdomain}.cobot.me"}, access_token)
    end
  end
end
