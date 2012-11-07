WebMock.disable_net_connect!

RSpec.configure do |c|
  c.before(:each) do
    WebMock.reset!
  end
end
