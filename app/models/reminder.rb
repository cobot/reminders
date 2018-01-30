class Reminder < ActiveRecord::Base
  validates_presence_of :subject, :body
  validates :days_before, numericality: {greater_than_or_equal_to: 1}
  validates :bcc, email: true, allow_blank: true
  validate :markup_valid?

  scope :active, ->() { where(deactivation_reason: nil) }

  def space
    @space ||= Space.find(space_id, access_token)
  end

  def active?
    !deactivation_reason?
  end

  def markup_valid?
    Liquid::Template.parse body
    rescue Liquid::SyntaxError => e
      errors.add :body, e.message
  end

  def deactivate(reason)
    update_attribute :deactivation_reason, reason
  end
end
