require 'spec_helper'

describe 'sending an invoice reminder', type: :feature do
  before(:each) do
    @reminder = Reminder.create! from_email: 'jane@doe.com',
      subject: 'Incoming invoice',
      body: <<-TXT,
        Hi {{ member.address.name }}. You will be receiving an invoice for your
        plan {{ plan.name }} costing
        {{plan.price | money}} {{plan.currency}} in {{days}} days.
        Extras: {% for extra in plan.extras %} {{extra.name}}: {{extra.price | money}} {{plan.currency}} {% endfor %}
      TXT
      days_before: 5 do |r|
        r.space_id = 'mutinerie'
    end
    stub_space 'mutinerie', email: 'crew@mutinerie.org'
    stub_request(:get, 'https://mutinerie.cobot.me/api/teams').to_return(body: [].to_json)
  end

  it 'sends an email to each member' do
    stub_memberships 'mutinerie', [
      {user: {email: 'joe@doe.com'}, address: {name: 'Xavier'}, charge_taxes: true, next_invoice_at: '2010-10-15', plan: {
        name: 'Basic Plan', price_per_cycle_in_cents: 10050, tax_rate: "10.00", currency: 'EUR',
        extras: [{name: 'Locker', price_in_cents: 2000, tax_rate: "20"}]}}]

    Timecop.travel(2010, 10, 10, 12) {
      InvoiceReminderService.send_reminders
    }

    expect(inbox_for('joe@doe.com')).to include_email(subject: 'Incoming invoice',
      body: <<-TXT.gsub(/\s+/, ' '),
        Hi Xavier.
        You will be receiving an invoice for your plan Basic Plan costing
        110.55 EUR in 5 days.
        Extras: Locker: 24.00 EUR
      TXT
      from: 'jane@doe.com')
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
    stub_memberships 'mutinerie', [
      {user: {email: 'joe@doe.com'}, address: {name: 'Xavier'}, id: '307401865340875',
        next_invoice_at: '2010-10-15', plan: {
          name: 'Basic Plan', price_per_cycle_in_cents: 12050, currency: 'EUR'}}]

    Timecop.travel(2010, 10, 10, 12) {
      InvoiceReminderService.send_reminders
    }

    expect(inbox_for('joe@doe.com')).to be_empty
  end

  it 'mentions other members paid for with old template that uses price_per_cycle' do
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
    stub_memberships 'mutinerie', [
      {user: {email: 'joe@doe.com'}, address: {name: 'Xavier'}, id: '307401865340876',
        next_invoice_at: '2010-10-15', plan: {
          name: 'Basic Plan', price_per_cycle_in_cents: 0, currency: 'EUR'}},
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
    stub_memberships 'mutinerie', [
      {user: {email: 'joe@doe.com'}, address: {name: 'Xavier'}, next_invoice_at: '2010-10-15', plan: {
        name: 'Basic Plan', price_per_cycle_in_cents: 12050, currency: 'EUR'}}]

    Timecop.travel(2010, 10, 10, 12) {
      InvoiceReminderService.send_reminders
    }

    expect(inbox_for('jane@doe.com')).to include_email(subject: 'Incoming invoice',
      body: 'Hi Xavier. You will be receiving an invoice for your plan Basic Plan costing 120.50 EUR in 5 days.')
  end

  it 'uses the upcoming plan if the current plan has been canceled to before the next invoice date' do
    stub_memberships 'mutinerie', [
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
    allow(Raven).to receive(:capture).and_yield
    WebMock.stub_request(:get, %r{spaces/mutinerie}).to_return(status: 404)

    expect {
      InvoiceReminderService.send_reminders
    }.to_not raise_error
  end

  it 'deactivates a reminder when getting a 403 response from cobot' do
    WebMock.stub_request(:get, %r{spaces/mutinerie}).to_return(status: 403)

    expect {
      InvoiceReminderService.send_reminders
    }.to_not raise_error

    stub_user spaces: ['mutinerie']
    visit root_path
    click_link 'Sign in', match: :first
    # save_and_open_page
    expect(page).to have_css('.inactive')
  end
end
