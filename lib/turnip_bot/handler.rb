require './lib/turnip_bot/prices'

module TurnipBot
  class Handler
    attr_reader :bot, :prices

    def initialize(bot)
      @bot = bot
      @prices = Prices.new
    end

    def process
      bot.message(start_with: /\d{2,}/) do |event|
        val = event.content.match(/\A\d{2,}/)
        if val
          turnip_price = val[0]
          author = event.author.username

          prices.add(event.timestamp, author, turnip_price)

          # TODO: Figure out how to pass unicode in
          event.message.react("🐗")
        else
          puts "@"*100
          puts "Error processing event"
          puts "event.author : #{event.author.username}"
          puts "event.content : #{event.content}"
          puts "event.timestamp : #{event.timestamp}"
          puts "@"*100
        end
      end

      bot.message(with_text: '!cheapest') do |event|
        event.respond determine_lowest
      end
      bot.message(with_text: '!lowest') do |event|
        event.respond determine_lowest
      end

      bot.message(with_text: '!highest') do |event|
        event.respond determine_highest
      end

      bot.message(with_text: '!prices') do |event|
        event.respond message determine_prices
      end

      bot.message(with_text: '!fact') do |event|
        event.respond 'Turnips are delicious and nutritious!'
      end
    end

    def determine_prices
      current_prices = prices.current_prices
      if current_prices.empty?
        "There are no turnip prices for today :("
      else
        messages = ["The most recent prices are:"]
        prices.current_prices.each do |author, price|
          messages << "  #{author} -> #{price}"
        end
        messages.join("\n")
      end
    end

    def determine_lowest
      current_prices = prices.current_prices
      if current_prices.empty?
        "There are no turnip prices for today :("
      else
        lowest = current_prices.min_by{|k, v| v}
        "The current lowest price is #{lowest[1]} from #{lowest[0]}"
      end
    end

    def determine_highest
      current_prices = prices.current_prices
      if current_prices.empty?
        "There are no turnip prices for today :("
      else
        highest = current_prices.max_by{|k, v| v}
        "The current highest price is #{highest[1]} from #{highest[0]}"
      end
    end
  end
end
