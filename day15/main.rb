# Advent of Code - Day x
require 'benchmark'
require_relative "../helpers"
require_relative "focus"
require_relative "cave_search"

test_cave_small = read_file_to_array_of_i("test.txt")
real_cave_small = read_file_to_array_of_i("input.txt")
test_cave_big = make_part_two_cave("test.txt")
real_cave_big = make_part_two_cave("input.txt")

puts "Excecute test big cave?"
x = gets.chomp
unless x == 'x'
  puts "Executing test cave big"
  time = Benchmark.measure do
    p process(test_cave_big)
  end
  puts "Execution time #{time.real}"
end

puts "Execute test small cave?"
x = gets.chomp
unless x == 'x'
  puts "Executing test cave small"
  time = Benchmark.measure do
    p process(test_cave_small)
  end
  puts "Execution time #{time.real}"
end
puts "Excecute real small cave?"
x = gets.chomp
unless x == 'x'
  puts "Executing real cave small"
  time = Benchmark.measure do
    p process(real_cave_small)
  end
  puts "Execution time #{time.real}"
end
