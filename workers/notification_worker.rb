require 'httparty'
response = HTTParty.post params[:callback_url]

unless response.success?
  raise response.body.to_s
end
