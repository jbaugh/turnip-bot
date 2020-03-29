require './lib/turnip_bot/prices'

module TurnipBot
  class Handler
    attr_reader :bot, :prices

    def initialize(bot)
      @bot = bot
      @prices = Prices.new
    end

    def process
      bot.reaction_add do |event|
        puts
        puts "REACTION!"
        puts
      end

      # This seems to be matching for every message, so the starts_with logic isnt behaving how we expect
      bot.message(starts_with: /\d{2,}/) do |event|
        val = event.content.match(/\A\d{2,}/)
        if val
          turnip_price = val[0]
          author = event.author.username

          prices.add(event.timestamp, author, turnip_price)

        else
          # puts "@"*100
          # puts "Error processing event"
          # puts event.inspect
          # puts "@"*100
        end
      end

      bot.message(with_text: '!turnip') do |event|
        current_prices = prices.current_prices
        if current_prices.empty?
          message = "There are no turnip prices :("  
        else
          messages = ["The most recent prices are:"]
          prices.current_prices.each do |author, price|
            messages << "  #{author} -> #{price}"
          end
          message = messages.join("\n")
        end

        event.respond message
      end

      bot.message(with_text: 'turnip') do |event|
        event.respond 'are delicious and nutritious!'
      end
    end
  end
end
