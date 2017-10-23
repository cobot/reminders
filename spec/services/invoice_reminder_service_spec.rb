require 'spec_helper'

describe InvoiceReminderService, '#call' do
  let(:service) { InvoiceReminderService.new }
  let(:membership) {
    stub(:membership, current_plan: plan, next_invoice_at: 2.days.from_now.to_date,
      user: stub(:user)).as_null_object }
  let(:plan) { stub(:plan, free?: false, canceled_to: nil) }
  let(:space) { stub(:space, teams: [], memberships: [membership]).as_null_object }
  let(:reminder) { stub(:reminder, space: space, days_before: 2) }

  before(:each) do
    ReminderMailer.stub(:invoice_reminder) {stub.as_null_object}
  end

  it 'sends an email to members whose next invoice is due in the given no. of days' do
    ReminderMailer.should_receive(:invoice_reminder).with(space, membership, reminder, nil)

    service.call reminder
  end

  it 'sends no email to members whose next invoice is not due in the given no. of days' do
    membership.stub(next_invoice_at: 3.days.from_now.to_date)

    ReminderMailer.should_not_receive(:invoice_reminder)

    service.call reminder
  end

  it 'sends no email to canceled members' do
    membership.stub(next_invoice_at: nil)

    ReminderMailer.should_not_receive(:invoice_reminder)

    service.call reminder
  end

  it 'sends no email to members on a free plan' do
    plan.stub(free?: true)

    ReminderMailer.should_not_receive(:invoice_reminder)

    service.call reminder
  end

  it 'sends no email to members without a user' do
    membership.stub(user: nil)

    ReminderMailer.should_not_receive(:invoice_reminder)

    service.call reminder
  end

  it 'removes canceled members from teams' do
    membership.stub(:id) { 'mem-1' }
    canceled_membership = stub(:canceled_membership, id: 'mem-2', next_invoice_at: nil)
    space.stub(:memberships) { [membership, canceled_membership] }
    team = {memberships: [{role: 'paying', membership: {id: 'mem-1'}},
                          {role: 'paid', membership: {id: 'mem-2'}}]}
    space.stub(:teams) { [team] }

    ReminderMailer.should_receive(:invoice_reminder).with(space, membership, reminder, nil)

    service.call reminder
  end
end
