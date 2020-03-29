require 'tzinfo'

module TurnipBot
  class Prices
    attr_reader :prices

    def initialize
      @prices = {}
    end

    def add(timestamp, author, price)
      timestamp = convert_to_local_time(timestamp)

      price_key = get_prices_key(timestamp)

      @prices[price_key] ||= {}
      @prices[price_key][author] = price

      puts "#{timestamp.strftime('%m-%d %H:%M')} :: #{author} has recorded a price of #{price}!"
    end

    def current_prices
      key = get_prices_key(convert_to_local_time(Time.now))
      prices[key] || {} 
    end

    private

    def get_prices_key(time)
      date_string(time) + "_" + time_of_day(time)
    end

    def time_of_day(time)
      if time.hour >= 12
        'evening'
      else
        'morning'
      end
    end

    def date_string(time)
      time.strftime('%m-%d')
    end

    def convert_to_local_time(time)
      tz = TZInfo::Timezone.get('America/Los_Angeles')
      tz.to_local(time)
    end
  end
end

