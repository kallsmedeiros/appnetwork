require 'rubygems'
require 'telegram/bot'
require 'telegram'

token = '270990880:AAHP6SUUI51zKptwoMsCeDy98YrpNz_WnyM'

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      bot.api.send_message(chat_id: message.chat.id,
                          text: "teste api telegra, #{message.from.first_name}")
    end
  end
end
