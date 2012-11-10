require 'httparty'
response = HTTParty.post params[:callback_url]

unless response.success?
  raise "API call error. Status: #{response.code}. Body: #{response.body.to_s.inspect}"
end
