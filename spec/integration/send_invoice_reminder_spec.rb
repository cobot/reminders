require 'spec_helper'

describe 'sending an invoice reminder' do
  before(:each) do
    @reminder = Reminder.create! subject: 'Incoming invoice',
      body: 'Hi {{ member.address.name }}. You will be receiving an invoice for your plan {{ plan.name }} costing {{plan.price_per_cycle | money}} {{plan.currency}} in {{days}} days.',
      days_before: 5 do |r|
        r.space_id = 'space-mutinerie'
    end
    stub_space 'space-mutinerie', email: 'crew@mutinerie.org'
  end

  it 'sends an email to each member' do
    stub_memberships 'space-mutinerie', [
      {user: {email: 'joe@doe.com'}, address: {name: 'Xavier'}, next_invoice_at: '2010-10-15', plan: {
        name: 'Basic Plan', price_per_cycle_in_cents: 12050, currency: 'EUR'}}]

    Timecop.travel(2010, 10, 10, 12) {
      InvoiceReminderService.send_reminders
    }

    expect(inbox_for('joe@doe.com')).to include_email(subject: 'Incoming invoice',
      body: 'Hi Xavier. You will be receiving an invoice for your plan Basic Plan costing 120.50 EUR in 5 days.',
      from: 'crew@mutinerie.org')
  end

  it 'bccs the email to the bcc address if one is set' do
    @reminder.update_attribute :bcc, 'jane@doe.com'
    stub_memberships 'space-mutinerie', [
      {user: {email: 'joe@doe.com'}, address: {name: 'Xavier'}, next_invoice_at: '2010-10-15', plan: {
        name: 'Basic Plan', price_per_cycle_in_cents: 12050, currency: 'EUR'}}]

    Timecop.travel(2010, 10, 10, 12) {
      InvoiceReminderService.send_reminders
    }

    expect(inbox_for('jane@doe.com')).to include_email(subject: 'Incoming invoice',
      body: 'Hi Xavier. You will be receiving an invoice for your plan Basic Plan costing 120.50 EUR in 5 days.')
  end

  it 'uses the upcoming plan if the current plan has been canceled to before the next invoice date' do
    stub_memberships 'space-mutinerie', [
      {user: {email: 'joe@doe.com'}, address: {name: 'Xavier'}, next_invoice_at: '2010-10-15',
        plan: {canceled_to: '2010-10-14'},
        upcoming_plan: {name: 'New Plan', price_per_cycle_in_cents: 10000, currency: 'EUR'}}]

    Timecop.travel(2010, 10, 10, 12) {
      InvoiceReminderService.send_reminders
    }

    expect(inbox_for('joe@doe.com')).to include_email(subject: 'Incoming invoice',
      body: 'Hi Xavier. You will be receiving an invoice for your plan New Plan costing 100.00 EUR in 5 days.')
  end
end
