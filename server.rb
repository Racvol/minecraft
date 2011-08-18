require 'em-websocket'

EventMachine.run {

    EventMachine::WebSocket.start(:host => "0.0.0.0", :port => 3050) do |ws|
        ws.onopen {
          puts "WebSocket connection open"
        }

        ws.onclose { puts "Connection closed" }
        ws.onmessage { |msg|
          puts "Recieved message: #{msg}"
          ws.send "#{msg}"
        }
    end
}

