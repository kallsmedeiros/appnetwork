require 'rubygems'
require 'telegram/bot'
require 'telegram'

token = '270990880:AAHP6SUUI51zKptwoMsCeDy98YrpNz_WnyM'

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
      bot.api.send_message(chat_id: message.chat.id,
                          text: "CHAT ameba, #{message.from.first_name}")
  end
end
