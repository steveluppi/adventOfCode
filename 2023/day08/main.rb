# Advent of Code - Day x
require_relative '../../helpers'

class Location
  attr_reader :location
  attr_reader :left
  attr_reader :right

  def initialize(location, left, right)
    @location = location
    @left = left
    @right = right
  end
  
  def inspect
    "#{@location} => #{@left}, #{@right}"
  end
  def to_s
    "#{@location} => #{@left}, #{@right}"
  end
end

def silver(input)
  map = input.shift.chars
  oper_len = map.length
  locations = {}
  input.each do |i|
    next if i.empty?
    break if i == 'stop'
    parts = i.scan(/\w{3}/)
    locations[parts[0]] = Location.new(parts[0],parts[1], parts[2])
  end

  steps = 0
  current_location = locations['AAA']
  puts "Starting at Location #{current_location}"
  while current_location.location != 'ZZZ'
    # puts "we are on step #{steps % oper_len} which is #{map[steps % oper_len]}"
    # puts "which means we move to #{map[steps%oper_len] == 'L' ? locations[current_location.left] : locations[current_location.right]}"
    current_location = map[steps%oper_len] == 'L' ? locations[current_location.left] : locations[current_location.right]
    steps += 1
  end

  steps
end

def gold(input)
  map = input.shift.chars
  oper_len = map.length
  locations = {}
  input.each do |i|
    next if i.empty?
    break if i == 'stop'
    parts = i.scan(/\w{3}/)
    locations[parts[0]] = Location.new(parts[0],parts[1], parts[2])
  end

  steps = 0
  current_locations = locations.values.select { |v| v.location =~ /A$/ }
  puts "Starting at Locations #{current_locations}"
  location_steps = Array.new(current_locations.length, 0)

  current_locations.each_with_index do |location, idx|
    current_location = location
    while current_location.location =~ /[^Z]$/
      current_location = map[location_steps[idx]%oper_len] == 'L' ? locations[current_location.left] : locations[current_location.right]
      location_steps[idx] += 1
    end
  end

  location_steps.reduce(1, :lcm)
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

# puts "Silver: #{silver(@input)}"
puts "Gold: #{gold(@input)}"
