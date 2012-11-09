class AuthenticationService
  def call(auth_hash)
    access_token = auth_hash.credentials.token
    find_user(auth_hash.uid) || create_user(auth_hash, access_token)
  end

  private

  def find_user(id)
    User.where(cobot_id: id).first
  end

  def create_user(auth_hash, access_token)
    User.create! do |user|
      user.cobot_id = auth_hash.uid
      user.access_token = access_token
      user.admin_of = auth_hash.extra.user_hash.admin_of
    end
  end
end
