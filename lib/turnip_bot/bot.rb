require 'discordrb'
require 'yaml'

require './lib/turnip_bot/handler'

class TurnipBot::Bot
  attr_reader :bot, :config, :handler

  def initialize
    @config = YAML.load_file('secrets.yml')
    @bot = Discordrb::Bot.new(token: config['bot_token'])
    @handler = TurnipBot::Handler.new(bot)
  end

  def run
    handler.process

    bot.run
  end
end