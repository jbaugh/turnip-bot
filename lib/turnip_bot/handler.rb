require './lib/turnip_bot/counts'

module TurnipBot
  class Handler
    attr_reader :bot, :counts

    def initialize(bot)
      @bot = bot
      @counts = Counts.new
    end

    def process
      bot.reaction_add do |event|
        puts
        puts "REACTION!"
        puts
      end

      bot.message(starts_with: /\d{2,}/) do |event|
        val = event.content.match(/\A\d{2,}/)
        if val
          turnip_count = val[0]
          author = event.author.username

          counts.add(event.timestamp, author, turnip_count) 
        else
          puts "@"*100
          puts "Error processing event"
          puts event.inspect
          puts "@"*100
        end
      end

      bot.message(with_text: 'turnip') do |event|
        event.respond 'are delicious and nutritious!'
      end
    end
  end
end
