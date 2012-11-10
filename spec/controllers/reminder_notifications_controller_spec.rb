require 'spec_helper'

describe ReminderNotificationsController, 'POST create' do
  let!(:reminder)  {
    stub(:reminder).tap do |reminder|
      Reminder.stub(all: [reminder])
    end

  }
  let!(:service) {
    stub(:service).as_null_object.tap do |service|
      InvoiceReminderService.stub(new: service)
    end
  }


  it 'calls the service' do
    service.should_receive(:call).with(reminder)

    post :create, token: Reminders::Config.api_token
  end

  it 'returns 201' do
    post :create, token: Reminders::Config.api_token

    expect(response.status).to eql(201)
  end

  it 'does not call the service if the api token is missing' do
    service.should_not_receive(:call)

    post :create
  end
end
