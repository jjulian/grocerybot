require 'uri'

class Sms
  def self.send(to, message)
    uri = URI.parse("https://rest.nexmo.com/sms/json")
    params = {
        'api_key' => ENV['NEXMO_API_KEY'],
        'api_secret' => ENV['NEXMO_API_SECRET'],
        'to' => to,
        'from' => ENV['NEXMO_NUMBER'],
        'text': message
    }
    Net::HTTP.post_form(uri, params)
  end
end
