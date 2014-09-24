require 'spec_helper'

describe 'sending an invoice reminder' do
  before(:each) do
    @reminder = Reminder.create! subject: 'Incoming invoice',
      body: 'Hi {{ member.address.name }}. You will be receiving an invoice for your plan {{ plan.name }} costing {{plan.price_per_cycle | money}} {{plan.currency}} in {{days}} days.',
      days_before: 5 do |r|
        r.space_id = 'space-mutinerie'
    end
    stub_space 'space-mutinerie', email: 'crew@mutinerie.org'
    stub_request(:get, 'https://mutinerie.cobot.me/api/teams').to_return(body: [].to_json)
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

  it 'does not send an email if the member is paid for by another' do
    stub_request(:get, 'https://mutinerie.cobot.me/api/teams').to_return(body: [
      {
        memberships: [
          {
            membership: {
              id: '307401865340875', name: 'Joe Doe'
            },
            role: 'paid'
          },
        ]
      }
    ].to_json)
    stub_memberships 'space-mutinerie', [
      {user: {email: 'joe@doe.com'}, address: {name: 'Xavier'}, id: '307401865340875',
        next_invoice_at: '2010-10-15', plan: {
          name: 'Basic Plan', price_per_cycle_in_cents: 12050, currency: 'EUR'}}]

    Timecop.travel(2010, 10, 10, 12) {
      InvoiceReminderService.send_reminders
    }

    expect(inbox_for('joe@doe.com')).to be_empty
  end

  it 'mentions other members paid for' do
    @reminder.update_attributes body: @reminder.body +
      <<-TXT
        {% if paid_for_members %}
          {% for m in paid_for_members %}
            {{m.address.name}}: {{ m.plan.name }}, {{m.plan.price_per_cycle | money}} {{m.plan.currency}}.
          {% endfor %}
        {% endif %}
      TXT
    stub_request(:get, 'https://mutinerie.cobot.me/api/teams').to_return(body: [
      {
        memberships: [
          {
            membership: {
              id: '307401865340875', name: 'Jane Doe'
            },
            role: 'paid'
          },
          {
            membership: {
              id: '307401865340876', name: 'Joe Doe'
            },
            role: 'paying'
          },
        ]
      }
    ].to_json)
    stub_memberships 'space-mutinerie', [
      {user: {email: 'joe@doe.com'}, address: {name: 'Xavier'}, id: '307401865340876',
        next_invoice_at: '2010-10-15', plan: {
          name: 'Basic Plan', price_per_cycle_in_cents: 12050, currency: 'EUR'}},
      {address: {name: 'Jane'}, id: '307401865340875',
        next_invoice_at: '2010-10-14', plan: {
          name: 'Team Plan', price_per_cycle_in_cents: 8000, currency: 'EUR'}}
    ]

    Timecop.travel(2010, 10, 10, 12) {
      InvoiceReminderService.send_reminders
    }

    expect(inbox_for('joe@doe.com')).to include_email(body: 'Jane: Team Plan, 80.00 EUR')
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

  it 'skips a deleted space' do
    Raven.stub(:capture).and_yield
    WebMock.stub_request(:get, %r{spaces/space-mutinerie}).to_return(status: 404)

    expect {
      InvoiceReminderService.send_reminders
    }.to_not raise_error
  end
end
