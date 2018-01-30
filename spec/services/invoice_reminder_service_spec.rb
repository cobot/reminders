require 'spec_helper'

describe InvoiceReminderService, '#call' do
  let(:service) { InvoiceReminderService.new }
  let(:membership) {
    double(:membership, current_plan: plan, next_invoice_at: 2.days.from_now.to_date,
      user: double(:user)).as_null_object }
  let(:plan) { double(:plan, free?: false, canceled_to: nil) }
  let(:space) { double(:space, teams: [], memberships: [membership]).as_null_object }
  let(:reminder) { double(:reminder, space: space, days_before: 2) }

  before(:each) do
    allow(ReminderMailer).to receive(:invoice_reminder) {double.as_null_object}
  end

  it 'sends an email to members whose next invoice is due in the given no. of days' do
    expect(ReminderMailer).to receive(:invoice_reminder).with(space, membership, reminder, nil)

    service.call reminder
  end

  it 'sends no email to members whose next invoice is not due in the given no. of days' do
    allow(membership).to receive_messages(next_invoice_at: 3.days.from_now.to_date)

    expect(ReminderMailer).not_to receive(:invoice_reminder)

    service.call reminder
  end

  it 'sends no email to canceled members' do
    allow(membership).to receive_messages(next_invoice_at: nil)

    expect(ReminderMailer).not_to receive(:invoice_reminder)

    service.call reminder
  end

  it 'sends no email to members on a free plan' do
    allow(plan).to receive_messages(free?: true)

    expect(ReminderMailer).not_to receive(:invoice_reminder)

    service.call reminder
  end

  it 'sends no email to members without a user' do
    allow(membership).to receive_messages(user: nil)

    expect(ReminderMailer).not_to receive(:invoice_reminder)

    service.call reminder
  end

  it 'removes canceled members from teams' do
    allow(membership).to receive(:id) { 'mem-1' }
    canceled_membership = double(:canceled_membership, id: 'mem-2', next_invoice_at: nil)
    allow(space).to receive(:memberships) { [membership, canceled_membership] }
    team = {memberships: [{role: 'paying', membership: {id: 'mem-1'}},
                          {role: 'paid', membership: {id: 'mem-2'}}]}
    allow(space).to receive(:teams) { [team] }

    expect(ReminderMailer).to receive(:invoice_reminder).with(space, membership, reminder, nil)

    service.call reminder
  end
end
