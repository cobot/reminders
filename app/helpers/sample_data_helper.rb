module SampleDataHelper
  def sample_membership
    Membership.new(user: CobotUser.new(email: 'joe@example.com'),
      plan: Plan.new(name: 'Full Time', price_per_cycle: 120, currency: 'EUR'),
      next_invoice_at: 2.days.from_now.to_date)
  end
end
