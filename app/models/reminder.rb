class Reminder < ActiveRecord::Base
  attr_accessible :subject, :body, :days_before

  def space
    @space ||= Space.find(space_id, access_token)
  end
end
