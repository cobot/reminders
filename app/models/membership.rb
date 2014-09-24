class Membership
  include Virtus

  attribute :id, String
  attribute :user, CobotUser
  attribute :plan, Plan
  attribute :upcoming_plan, Plan
  attribute :address, Address
  attribute :next_invoice_at, Date

  def initialize(attribute)
    super attribute
  end

  def current_plan
    if plan.canceled_to && plan.canceled_to < next_invoice_at
      upcoming_plan
    else
      plan
    end
  end
end
