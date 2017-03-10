require 'sinatra'
require 'net/http'
require 'robot'
require 'sms'
require 'json'

require 'active_record'
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || YAML::load(File.open('config/database.yml')))
require 'models/item'


get '/incoming' do
  sender_phone = params['msisdn']
  message_text = params['text']

  reply_text = Robot.new(creator: sender_phone).reply_to(message_text)

  if ENV['RACK_ENV'] == 'production'
    response = Sms.send(sender_phone, reply_text)
    [200, "ok"]
  else
    "<p>OK</p><p>#{params}</p><p>#{reply_text}</p>"
  end
end
