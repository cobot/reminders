class Reminder < ActiveRecord::Base
  attr_accessible :subject, :body, :days_before
end
