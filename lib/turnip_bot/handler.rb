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
          price = val[0]
          record_price(event, price)
        else
          puts "@"*100
          puts "Error processing event"
          puts "event.author : #{event.author.username}"
          puts "event.content : #{event.content}"
          puts "event.timestamp : #{event.timestamp}"
          puts "@"*100
        end
      end

      bot.message(start_with: '!turnip') do |event|
        # Remove any non numbers
        price = event.content.gsub(/\D/, '')
        # Make sure the price is a number
        record_price(event, price) if price.to_i > 0
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
        event.respond determine_prices
      end

      bot.message(with_text: '!fact') do |event|
        event.respond random_turnip_fact(event.author.username)
      end
    end

    def record_price(event, price)
      prices.add(event.timestamp, event.author.username, price.to_i)

      # TODO: Figure out how to pass unicode in
      event.message.react("🐗")
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

    def random_turnip_fact(username)
      [
        'Turnips are delicious and nutritious!',
        'Turnips are commonly grown in temperate climates worldwide for its white, fleshy taproot.',
        'There are over 30 varieties of turnips which differ in size, color, flavor and usage.',
        'Purple-top turnips are the most common type.',
        'Smaller kinds of turnip are grown for human food. Larger ones are grown to feed livestock.',
        'The turnip is a hardy biennial plant in the mustard family.',
        'The turnip root is roughly globular, from 5 to 20 centimetres (2 to 8 in) in diameter, and lacks side roots.',
        'The heaviest turnip weighed 17.7 kg (39 lb 3 oz)! Wow!',
        'Turnip greens are a common side dish in southeastern U.S. cooking.',
        'Turnip roots are excellent source of dietary fiber, vitamin C and vitamin B6, folate, calcium, potassium, and copper.',
        'Turnip greens are an excellent source of vitamins A and C, as well as a good source of calcium, iron, and riboflavin.',
        'In Roman times, the turnip was the weapon of choice to hurl at unpopular public figures.',
        'The Turnip is a hardy plant that has been cultivated for over 4,000 years!',
        'Andy once stuffed 26 whole turnips in his mouth!',
        'Wail builds his own turnips.',
        'Vincent invented turnips.',
        'If Saul has one more turnip, he could have a heart attack.',
        'Jacob once survived a month on nothing but turnips.',
        "#{username} is allergic to turnips!",
        "#{username} has never tried a turnip!"
      ].shuffle.first
    end
  end
end
