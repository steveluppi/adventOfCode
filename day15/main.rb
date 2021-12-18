# Advent of Code - Day x
require 'benchmark'
require_relative "../helpers"
require_relative "focus"
require_relative "cave_search"

test_cave_small = read_file_to_array_of_i("test.txt")
real_cave_small = read_file_to_array_of_i("input.txt")
test_cave_big = make_part_two_cave("test.txt")
real_cave_big = make_part_two_cave("input.txt")

def exec_it(name, cave)
  puts "Running #{name}"
  time = Benchmark.measure do
    p process(cave)
  end
  puts "#{name} timing #{time.real}"
end

exec_it("hardcoded test big", test_cave_big)
exit

puts "TEST : BIG"
x = gets.chomp
exec_it("TEST BIG",test_cave_big) unless x == 'x'

puts "TEST : SMALL"
x = gets.chomp
exec_it("TEST SMALL",test_cave_small) unless x=='x'

puts "REAL : SMALL"
x = gets.chomp
exec_it("REAL SMALL",real_cave_small) unless x == 'x'
