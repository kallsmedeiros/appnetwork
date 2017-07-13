Telegram.init

Telegram.contact_list
     
# Send message
users = Telegram.contact_list
user = users.find{|user| user.phone == "+5511987390125"}
Telegram.send_message(user.to_peer, "Hello from TelegramRb #{rand(1000)}")
     
# Receive message callback
module Telegram
  def self.receive_message(message)
    p message.inspect
  end
end

Telegram.poll_messages
