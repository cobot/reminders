require 'spec_helper'

describe 'sending an invoice reminder' do
  it 'sends an email to each member' do
    reminder = Reminder.create! subject: 'Incoming invoice',
      body: 'You will be receiving an invoice for your plan {{ plan.name }} costing {{plan.price_per_cycle | money}} {{plan.currency}} in {{days}} days.',
      days_before: 5 do |r|
        r.space_id = 'space-mutinerie'
    end
    stub_space 'space-mutinerie'
    stub_memberships 'space-mutinerie', [
      {user: {email: 'joe@doe.com'}, next_invoice_at: '2010-10-15', plan: {
        name: 'Basic Plan', price_per_cycle_in_cents: 12050, currency: 'EUR'}}]

    Timecop.travel(2010, 10, 10, 12) {
      post reminder_notifications_path, token: Reminders::Config.api_token
    }

    expect(inbox_for('joe@doe.com')).to include_email(subject: 'Incoming invoice',
      body: 'You will be receiving an invoice for your plan Basic Plan costing 120.50 EUR in 5 days.')
  end
end
