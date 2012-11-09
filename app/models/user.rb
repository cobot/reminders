class User < ActiveRecord::Base
  serialize :admin_of

  def spaces
    admin_of.map do |admin|
      Space.new({url: admin['space_link']}, access_token)
    end
  end
end
