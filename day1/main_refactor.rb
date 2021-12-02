# Advent of Code - Day 1
require_relative "../helpers"

def sweep(input)
  depth_increase_count = 0

  input.each_with_index do |depth, idx|
    next if idx == 0
    depth_increase_count += 1 if depth > input[idx-1]
  end

  depth_increase_count
end

def sliding_window(input)
  windowed_array = []

  input.each_with_index do |depth, index|
    next if index < 2
    windowed_array.push(input[(index-2)..index].reduce(:+))
  end

  windowed_array
end

puts "#{sweep(array_to_i(read_file_and_chomp("input.txt")))} Increases occur"
puts "#{sweep(sliding_window(array_to_i(read_file_and_chomp("input.txt"))))} Increases occur with a sliding window"
