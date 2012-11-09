class AuthenticationService
  def call(auth_hash)
    access_token = auth_hash['credentials']['token']

    User.create! do |user|
      user.cobot_id = auth_hash.uid
      user.access_token = access_token
      user.admin_of = auth_hash.extra.user_hash.admin_of
    end
  end
end
