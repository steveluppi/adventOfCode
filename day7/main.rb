# Advent of Code - Day 7
require_relative "../helpers"

def process(input)
  target =  mean(input).floor
  movement = input.reduce(0) {|m, n| m+=(0..((n-target).abs)).sum; m}
  movement
end

def median(input)
  input.sort[input.size / 2]
end
def mean(input)
  (input.reduce(0){|sum,n| sum += n} / input.size.to_f)
end

puts "#{process(read_file_to_array("input.txt"))}"
