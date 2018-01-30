module AuthenticationHelpers
  def log_in(user)
    allow(User).to receive(:find).with(1) {user}
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

  # rspec-rails 3 will no longer automatically infer an example group's spec type
  # from the file location. You can explicitly opt-in to the feature using this
  # config option.
  # To explicitly tag specs without using automatic inference, set the `:type`
  # metadata manually:
  #
  #     describe ThingsController, :type => :controller do
  #       # Equivalent to being in spec/controllers
  #     end
  c.infer_spec_type_from_file_location!
end


