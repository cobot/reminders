class Membership
  include Virtus

  attribute :user, CobotUser
  attribute :plan, Plan
  attribute :address, Address
  attribute :next_invoice_at, Date

  def initialize(attribute)
    super attribute
  end
end
