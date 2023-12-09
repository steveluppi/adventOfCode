# Advent of Code - Day x
require_relative '../../helpers'

DEBUG = false

def calc_history_val(input)
  puts "calc_history_va on: #{input}" if DEBUG
  # p input

  diffs = []

  input.each_with_index do |i, idx|
    # puts 'before'
    # p diffs
    next if idx == 0
    diffs << (i - input[idx-1])
    # puts "after"
    # p diffs
  end
  
  puts "  which made diffs #{diffs}" if DEBUG

  return 0 if diffs.all? { |d| d == 0 }

  aggregate_val = calc_history_val(diffs)
  puts "lets calculate the next number with #{aggregate_val} and #{diffs}" if DEBUG

  this_number = diffs.pop
  next_number = aggregate_val + this_number

  next_number
end

def silver(input)
  next_histories = []
  input.each do |i|
    break if i == 'stop'
    val = calc_history_val(i.split(' ').map(&:to_i))
    puts "and we got #{val} which should be added to the thing" if DEBUG
    thing = i.split(' ').pop.to_i
    puts "#{thing + val} is the answer?" if DEBUG
    next_histories << thing+val
  end

  next_histories.inject(:+)
end

def calc_prev_history_val(input)
  puts "calc_history_va on: #{input}" if DEBUG

  diffs = []

  input.each_with_index do |i, idx|
    next if idx == 0
    diffs << (i - input[idx-1])
  end
  
  puts "  which made diffs #{diffs}" if DEBUG

  return 0 if diffs.all? { |d| d == 0 }

  aggregate_val = calc_prev_history_val(diffs)
  puts "lets calculate the next number with #{aggregate_val} and #{diffs}" if DEBUG

  this_number = diffs.shift
  next_number = this_number - aggregate_val
  puts "next number is #{next_number}" if DEBUG

  next_number
end

def gold(input)
  next_histories = []
  input.each do |i|
    break if i == 'stop'
    val = calc_prev_history_val(i.split(' ').map(&:to_i))
    puts "and we got #{val} which should be added to the thing" if DEBUG
    thing = i.split(' ').shift.to_i
    puts "#{thing - val} is the answer?" if DEBUG
    next_histories << thing - val
  end

  next_histories.inject(:+)
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
