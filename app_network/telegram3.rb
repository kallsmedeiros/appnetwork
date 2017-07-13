require 'rubygems'
require 'telegram/bot'
require 'telegram'

token = '270990880:AAHP6SUUI51zKptwoMsCeDy98YrpNz_WnyM'
identidade = '156657831'
Telegram::Bot::Client.run(token) do |bot|
#  bot.listen do |message|
      bot.api.send_message(chat_id: identidade, text: "CHAT ameba") #,{#message.from.first_name}")
#  end
end
