Rails.application.config.middleware.use OmniAuth::Builder do
  provider :cobot, '<client_id>', '<client_secret>', scope: 'read write'
end
