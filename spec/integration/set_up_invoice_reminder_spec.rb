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
