class Membership
  include Virtus.model

  attribute :id, String
  attribute :user, CobotUser
  attribute :plan, Plan
  attribute :upcoming_plan, Plan
  attribute :address, Address
  attribute :next_invoice_at, Date
  attribute :charge_taxes, Boolean

  def initialize(attributes)
    attributes[:plan][:charge_taxes] = attributes[:charge_taxes]
    attributes[:upcoming_plan][:charge_taxes] = attributes[:charge_taxes] if attributes[:upcoming_plan]
    super attributes
  end

  def current_plan
    if plan.canceled_to && plan.canceled_to <= next_invoice_at
      upcoming_plan
    else
      plan
    end
  end
end
