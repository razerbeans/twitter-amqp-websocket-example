require 'vendor/gems/environment'
require 'em-websocket'
require 'mq'
require 'json'

EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 8080) do |ws|
  ws.onopen do
    puts "WebSocket opened"

    twitter = MQ.new
    twitter.queue('twitter').bind(twitter.fanout('twitter')).subscribe do |t|
      ws.send Marshal.load(t).to_json
    end
  end

  ws.onclose do
    puts "WebSocket closed"
  end
end
