source 'https://rubygems.org'

ruby '2.7.7'

gem 'rails', '~>4.2.11'
gem 'bigdecimal', '1.3.5' # to make ruby 2.7 work with rails 4.2
gem 'oauth2'
gem 'virtus'
gem 'liquid'
gem 'simple_form'
gem 'email_validator'
gem 'sentry-raven'
gem 'pg', '~>0.21'
gem 'omniauth'
gem 'omniauth-oauth2'
gem 'omniauth_cobot', '~>0.0.3'
gem 'cobot_client'
gem 'simple_postmark'
gem 'jquery-rails'
gem 'test-unit'
gem 'librato-metrics'
gem 'sass-rails'
gem 'uglifier', '>= 1.0.3'
gem 'rspec-rails', groups: [:test, :development]

group :production do
  gem 'lograge'
  gem 'puma'
  gem 'rails_12factor'
end

group :test do
  gem 'capybara'
  gem 'launchy'
  gem 'webmock', require: 'webmock/rspec'
  gem 'timecop'
end
