require 'raven'

if ENV['RAVEN_DSN']
  Raven.configure do |config|
    config.dsn = ENV['RAVEN_DSN']
    config.release = ENV['HEROKU_RELEASE_VERSION']
  end
end
