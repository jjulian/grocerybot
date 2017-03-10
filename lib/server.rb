require 'sinatra'
require 'net/http'
require 'robot'
require 'sms'
require 'json'

require 'active_record'
ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'] || YAML::load(File.open('config/database.yml')))
require 'models/item'


get '/' do
  "Hello World! I'm the grocery bot."
end

get '/talk' do
  #
  # # ensure there is an inbound message
  # if !params['to'].nil? || !params['msisdn'].nil? || !params['text'].nil?
  #     puts "Got message from #{params['msisdn']}: "
  # elsif !params['concat']
  #   #Create or open peristent storage
  #   message_parts = PStore.new(params['concat-ref'])
  #   #Add this part of the message
  #   message_parts.transaction do
  #     message_parts[ params['concat-part']] = params['text']
  #   end
  #   no_of_parts = message_parts.size
  #   if params['concat-total'].to_i == no_of_parts
  #     message_parts.transaction(true) do  # begin read-only transaction, no changes allowed
  #       message_parts.roots.each do |message_part|
  #         message = message + message_part
  #       end
  #     end
  #   end
  # elsif !message.nil?
  #   message = params['text']
  # end

  sender = params['msisdn']
  message = params['text']
  puts "#{sender} says #{message}"

  reply = Robot.new(creator: sender).reply_to(message)

  if ENV['RACK_ENV'] == 'production'
    response = Sms.send(sender, reply).body
  else
    response = reply
  end

  puts params.merge({reply: reply}).to_json

  "OK\n#{params}\n#{response}"
end
