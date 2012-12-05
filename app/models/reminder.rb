class Reminder < ActiveRecord::Base
  attr_accessible :subject, :body, :days_before, :bcc

  validates_presence_of :subject, :body
  validates :bcc, email: true, allow_blank: true

  def space
    @space ||= Space.find(space_id, access_token)
  end
end
