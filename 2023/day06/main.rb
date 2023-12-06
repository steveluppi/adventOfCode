# Advent of Code - Day x
require_relative '../../helpers'


def silver(input)
  times = nil
  records = nil
  input.each do |i|
    case i
    when /^Time/
      times=i.scan(/(\d+)/).flatten.map(&:to_i)
      p times
    when /^Distance/
      records=i.scan(/(\d+)/).flatten.map(&:to_i)
      p records
    end
  end

  ways_to_win = []

  times.each_with_index do |time, idx|
    wins=0
    record = records[idx]
    time.times do |ms|
      next if ms == 0
      next if ms == time
      puts "Holding #{ms} ms will make you have #{time-ms} left to go #{(time-ms) * ms}"
      wins += 1 if (time-ms) * ms > record
    end
    ways_to_win << wins
  end
  p ways_to_win

  ways_to_win.inject(:*)
end

def gold(input)
  times = nil
  records = nil
  input.each do |i|
    case i
    when /^Time/
      times=[i.scan(/(\d+)/).flatten.join.to_i]
      p times
    when /^Distance/
      records=[i.scan(/(\d+)/).flatten.join.to_i]
      p records
    end
  end

  ways_to_win = []

  times.each_with_index do |time, idx|
    wins=0
    record = records[idx]
    time.times do |ms|
      next if ms == 0
      next if ms == time
      # puts "Holding #{ms} ms will make you have #{time-ms} left to go #{(time-ms) * ms}"
      wins += 1 if (time-ms) * ms > record
    end
    ways_to_win << wins
  end
  p ways_to_win

  ways_to_win.inject(:*)
end

# Main execution
@input = read_file_and_chomp(
  case ARGV[0]
  when 'silver'
    'silver.txt'
  when 'gold'
    'gold.txt'
  else
    'example.txt'
  end
)

puts "Silver: #{silver(@input)}"
puts "Gold: #{gold(@input)}"
