# Advent of Code - Day x
require_relative '../../helpers'

def get_mapped_value(input, map)
  # find the mapping for which the input falls.
  map.each do |map_set|
    # puts "#{map_set[1]..map_set[2]+map_set[1]-1}"
    if (map_set[1]..map_set[2] + map_set[1]).member?(input)
      offset = input - map_set[1]
      return map_set[0] + offset
    end
  end
  input
end

# This is a seed class
class PlantSeed
  def initialize(seed_number)
    @seed_number = seed_number
  end

  def soil
    get_mapped_value(@seed_number, $map['seed-to-soil'])
  end

  def fertilizer
    get_mapped_value(soil, $map['soil-to-fertilizer'])
  end

  def water
    get_mapped_value(fertilizer, $map['fertilizer-to-water'])
  end

  def light
    get_mapped_value(water, $map['water-to-light'])
  end

  def temperature
    get_mapped_value(light, $map['light-to-temperature'])
  end

  def humidity
    get_mapped_value(temperature, $map['temperature-to-humidity'])
  end

  def location
    get_mapped_value(humidity, $map['humidity-to-location'])
  end
end

def parse_input_to_objects(input)
  map_key = nil
  seeds = []
  input.each do |line|
    case line
    when /^seeds/
      puts 'Parsing Seeds line...'
      nums = line.split(':')[1].split(' ').compact.map(&:to_i)
      seeds = nums.map { |n| PlantSeed.new(n) }
    when /.*map:$/
      name = line.scan(/^([\w-]+)\ /).first.first
      puts "Found a new Mapping with name #{name}"
      map_key = name
      $map[map_key] = []
    when /^$/
      next
    else
      $map[map_key] << line.split(' ').map(&:to_i)
    end
  end
  seeds
end

def parse_gold(input)
  map_key = nil
  # seeds = []
  min=nil
  input.each do |line|
    case line
    when /^seeds/
      puts 'Parsing Seeds line...'
      nums = line.split(':')[1].split(' ').compact.map(&:to_i)
      while nums.size>0
        start = nums.shift
        count = nums.shift
        puts "#{start} is the start and #{count} is the count"
        count.times do |i|
          # puts start+i
          min = [min, PlantSeed.new(start+i).location].compact.min
        end
      end
    when /.*map:$/
      next # this was handled as part of silver
      name = line.scan(/^([\w-]+)\ /).first.first
      puts "Found a new Mapping with name #{name}"
      map_key = name
      $map[map_key] = []
    when /^$/
      next
    else
      next # this was handled as part of silver
      $map[map_key] << line.split(' ').map(&:to_i)
    end
  end
  min
end

def silver(input)
  # p $map
  # input.each do |i|
  #   puts i.location
  # end

  input.map(&:location).min
end

def gold(input)
  # input.map(&:location).min
  input
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

$map = {}

puts "Silver: #{silver(parse_input_to_objects(@input))}"
puts "Gold: #{gold(parse_gold(@input))}"

# $map = {
#   'seed-to-soil': [[50, 98, 2], [52, 50, 48]],
#   'soil-to-fertilizer': [[0, 15, 37], [37, 52, 2], [39, 0, 15]]
# }
