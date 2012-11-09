Rails.application.config.middleware.use OmniAuth::Builder do
  provider :cobot, Reminders::Config.app_id,  Reminders::Config.app_secret, scope: 'read'
end
