source 'https://rubygems.org'

ruby '2.1.5'

gem 'rails', '~>3.2.19'
gem 'oauth2'
gem 'virtus'
gem 'liquid'
gem 'simple_form'
gem 'email_validator'
gem 'sentry-raven'
gem 'remote_syslog_logger'
gem 'pg'
gem 'omniauth'
gem 'omniauth-oauth2'
gem 'omniauth_cobot', '~>0.0.3'
gem 'cobot_client'
gem 'simple_postmark'
gem 'jquery-rails'

group :production do
  gem 'lograge'
  gem 'rails_12factor'
  gem 'puma'
end

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'webmock', require: 'webmock/rspec'
  gem 'launchy'
  gem 'timecop'
end
