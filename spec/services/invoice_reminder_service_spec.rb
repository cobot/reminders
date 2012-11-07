require 'spec_helper'

describe InvoiceReminderService, '#call' do
  it 'sends an email to members whose next invoice is due in the given no. of days' do
    service.call
  end

  it 'sends no email to members whose next invocie is not due in the given no. of days'

  it 'sends no email to canceled members'

  it 'sends no email to members on a free plan'

  it 'sends no email to members without a user'
end
