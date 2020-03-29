require 'tzinfo'

module TurnipBot
  class Counts
    attr_reader :counts

    def initialize
      @counts = {}
    end

    def add(timestamp, author, count)
      timestamp = convert_to_local_time(timestamp)

      count_key = get_counts_key(timestamp)

      @counts[count_key] ||= {}
      @counts[count_key][author] = count

      puts "#{timestamp.strftime('%m-%d %H:%M')} :: #{author} has recorded a count of #{count}!"
    end

    def current_counts
      key = get_counts_key(convert_to_local_time(Time.now))
      counts[key] || {} 
    end

    private

    def get_counts_key(time)
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

