class Reminder < ActiveRecord::Base
  attr_accessible :subject, :body, :days_before, :bcc, :from_email

  validates_presence_of :subject, :body
  validates :days_before, numericality: {greater_than_or_equal_to: 1}
  validates :bcc, email: true, allow_blank: true
  validate :markup_valid?

  def space
    @space ||= Space.find(space_id, access_token)
  end

  def markup_valid?
    Liquid::Template.parse body
    rescue Liquid::SyntaxError => e
      errors.add :body, e.message
  end
end
