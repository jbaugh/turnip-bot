require 'yaml'
require 'date'

# Sample data
# data = {
#   "03-25_morning" => {
#     "Joe" => 33,
#     "Smithie" => 62,
#     "Fred" => 32,
#     "James" => 36,
#   },
#   "03-25_evening" => {
#     "Joe" => 35,
#     "Smithie" => 24,
#     "James" => 41,
#   },
#   "03-26_morning" => {
#   },
#   "03-26_evening" => {
#     "Smithie" => 124,
#   },
# }

# TurnipBot::Store.new.save(data)
# TurnipBot::Store.new.load


module TurnipBot
  class Store
    LOAD_RANGE_DAYS = 7
    TIMES_OF_DAY = ['morning', 'evening']

    def load
      data = {}
      date = Date.today
      date = date - (LOAD_RANGE_DAYS - 1)
      LOAD_RANGE_DAYS.times do
        TIMES_OF_DAY.each do |time_of_day|
          filename = "#{date.strftime('%m-%d')}_#{time_of_day}"
          if File.exists?("./data/#{filename}.yml")
            data[filename] = YAML.load_file("./data/#{filename}.yml")
          end
        end
        date += 1
      end
      data
    end

    def save(data)
      data.each do |date_str, values|
        File.open("./data/#{date_str}.yml", 'w') do |file|
          file.puts YAML.dump(values)
        end
      end
    end
  end
end

