require 'spec_helper'

describe 'logging in' do
  it 'show me my reminders' do
    stub_user id: '1', spaces: ['mutinerie']
    User.create! do |user|
      user.cobot_id = '1'
      user.admin_of = [{'space_link' => "https://www.cobot.me/api/spaces/mutinerie"}]
    end
    Reminder.create!(subject: 'invoice coming', body: '-', days_before: 1) {|reminder|
      reminder.space_id = 'mutinerie'
    }

    visit root_path
    click_link 'Sign in'

    expect(page).to have_content('invoice coming')
  end
end
