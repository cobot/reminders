require 'spec_helper'

describe 'settings up an invoice reminder' do
  it 'saves the reminder' do
    stub_user spaces: ['mutinerie']
    visit root_path
    click_link 'Sign in'
    fill_in 'Subject', with: 'invoice coming'
    fill_in 'Body', with: 'price: {{ price }}'
    fill_in 'Days before', with: '4'
    click_button 'Set Reminder'

    visit space_reminders_path('mutinerie')
    expect(page).to have_content('invoice coming')
  end
end

describe 'editing an invoice reminder' do
  before(:each) do
    stub_user spaces: ['mutinerie']
    visit root_path
    click_link 'Sign in'
    Reminder.create!(subject: 'invoice coming', body: '-', days_before: 1) {|reminder|
      reminder.space_id = 'mutinerie'
    }
  end

  it 'changes the reminder' do
    visit space_reminders_path('mutinerie')
    click_link 'Edit'

    fill_in 'Subject', with: 'Invoice incoming'
    click_button 'Change Reminder'

    visit space_reminders_path('mutinerie')
    expect(page).to have_content('Invoice incoming')
  end
end

describe 'deleting an invoice reminder' do
  before(:each) do
    stub_user spaces: ['mutinerie']
    visit root_path
    click_link 'Sign in'
    Reminder.create!(subject: 'invoice coming', body: '-', days_before: 1) {|reminder|
      reminder.space_id = 'mutinerie'
    }
  end

  it 'removes a reminder' do
    visit space_reminders_path('mutinerie')
    click_link 'Remove'

    visit space_reminders_path('mutinerie')
    expect(page).to have_no_content('invoice coming')
  end
end
