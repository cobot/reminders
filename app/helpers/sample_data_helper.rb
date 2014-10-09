module SampleDataHelper
  def sample_membership
    Membership.new(user: CobotUser.new(email: 'joe@example.com'),
      address: Address.new(name: 'John Doe', company: 'ACME Corp.', address: '1 Broadway',
        city: 'San Francisco', state: 'CA', country: 'United States', post_code: '94513'),
      plan: Plan.new(name: 'Full Time', price_per_cycle_in_cents: 12000, currency: 'EUR',
        extras: [{name: 'Locker', price_in_cents: 2500}]),
      next_invoice_at: 2.days.from_now.to_date)
  end
end
