require 'sinatra'
require "net/http"
require "uri"

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


  reply = parse_text(message)
  response = reply_via_sms(sender, reply)

  "OK\n#{params}\n#{response}"
end

def parse_text(text)
  # separators ,.:;|
  if text =~ /\bneed\b(.+)|\badd\b(.+)/
    'OK, added.'
    # TODO parse and update db
  elsif text =~ /\bremove\b(.+)/
    'OK, removed.'
    # TODO parse and update db
  elsif text =~ /\bclear\b|\bdone\b/
    'Your list is empty.'
    # TODO parse and update db
  elsif text =~ /\blist\b|\bshow\b/
    'Here\'s what you need so far:'
    # TODO enumerate
  else
    'Hmm. I didn\'t quite get that. Use "need" or "remove" or "list".'
  end
end

def reply_via_sms(to, message)
  uri = URI.parse("https://rest.nexmo.com/sms/json")
  params = {
      'api_key' => ENV['NEXMO_API_KEY'],
      'api_secret' => ENV['NEXMO_API_SECRET'],
      'to' => to,
      'from' => ENV['NEXMO_NUMBER'],
      'text': message
  }
  Net::HTTP.post_form(uri, params).body
end
