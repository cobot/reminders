module AuthenticationHelpers
  def log_in(user)
    User.stub(:find).with(1) {user}
    session[:user_id] = 1
  end

  def stub_user(options = {})
    spaces = (options[:spaces] || []).map{|subdomain| {space_link: "https://www.cobot.me/api/spaces/#{subdomain}"}}
    OmniAuth.config.add_mock :cobot,
      credentials: {token: 'access-token-1'},
      provider: 'cobot',
      uid: options[:id] || '123545',
      "user_info"=>{"name"=>"janesmith",
        "email"=>"janesmith@example.com"},
      extra: {
        raw_info: {
          login: "janesmith",
          email: "janesmith@example.com",
          id: "user-janesmith",
          "memberships"=>[],
          "admin_of"=> spaces
          }
        }
  end
end

RSpec.configure do |c|
  c.send :include, AuthenticationHelpers
end


