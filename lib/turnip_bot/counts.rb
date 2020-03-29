module TurnipBot
  class Counts
    attr_reader :counts

    def initialize
      @counts = {}
    end

    def add(timestamp, author, count)
      time = timestamp.strftime('%m-%d %H:%M')



      puts "#{time} :: #{author} has recorded a count of #{count}!"
    end
  end
end

