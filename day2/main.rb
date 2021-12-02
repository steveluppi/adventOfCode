# Advent of Code - Day 2
require_relative "../helpers"

def parse_movement(input)
  parts = input.split(' ')
  return {direction: parts[0], delta: parts[1].to_i}
end

def parse_to_movement_array(input)
  movements = []
  input.each do |movement|
    movements.push(parse_movement(movement))
  end
  movements
end

def process(input)
  location = {depth:0, distance:0}
  parse_to_movement_array(input).each do |movement| 
    case movement[:direction]
    when "up"
      location[:depth]-=movement[:delta]
    when "down"
      location[:depth]+=movement[:delta]
    when "forward"
      location[:distance]+=movement[:delta]
    else 
      puts "Unknown Direction"
    end
  end
  location[:depth] * location[:distance]
end

puts "#{process(read_file_and_chomp("input.txt"))}"
