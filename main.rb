require 'discordrb'
require 'yaml'

config = YAML.load_file('secrets.yml')

bot = Discordrb::Bot.new(token: config['bot_token'])

# bot.message(with_text: 'Ping!') do |event|
#   event.respond 'Pong!'
# end

bot.run(true)

# bot.send_message(config['channel_id'], 'turnips are nutritious and delicious!')

bot.stop
