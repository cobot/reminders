module EmailHelpers
  def inbox_for(email_address)
    ActionMailer::Base.deliveries.select{|email| (email.to + (email.bcc || [])).include?(email_address)}
  end
end

RSpec.configure do |c|
  c.send :include, EmailHelpers
  c.before(:each) do
    ActionMailer::Base.deliveries.clear
  end
end

RSpec::Matchers.define :include_email do |options|
  match do |emails|
    matching_email = emails.find do |email|
      match = true
      if options[:subject]
        match &&= email.subject =~ /#{options[:subject]}/
      end
      if options[:body]
        match &&= email.body.to_s.include?(options[:body])
      end
      if options[:from]
        match &&= [options[:from]] == email.from
      end
      match
    end
    expect(matching_email).to be_present
  end
end
