# Advent of Code - Day 3
require_relative "../helpers"

def read_power(input)
  # total the bits
  bit_totals = []
  total_readings = 0

  input.each do |reading|
    reading.split('').each_with_index do |bit,idx|
      bit_totals[idx] = 0 if bit_totals[idx].nil?
      bit_totals[idx] += (bit.to_i(2) & 1)
    end

    total_readings += 1
  end

  # calculate gamma and epsilon
  g, e, midpoint = "","", total_readings / 2
  bit_totals.each_with_index do |bit, idx|
    puts "WHAT IF SAME" if bit == midpoint
    if bit > midpoint
      g+="1"
      e+="0"
    else
      g+="0"
      e+="1"
    end
  end

  g.to_i(2) * e.to_i(2)
end

def read_life_support_rating(input)
  def determine_position_bit_totals(input, position)
    bit_totals = []
    total_readings = 0

    input.each do |reading|
      reading.split('').each_with_index do |bit,idx|
        bit_totals[idx] = 0 if bit_totals[idx].nil?
        bit_totals[idx] += (bit.to_i(2) & 1)
      end

      total_readings += 1
    end
    bit_totals[position].to_f >= total_readings/2.0 ? "1" : "0"
  end

  def read_oxygen(input, position)
    matcher = determine_position_bit_totals(input, position)
    filtered = []

    input.each { |i| filtered.push(i) if i[position] == matcher}

    return filtered[0] if filtered.length<=1
    read_oxygen(filtered, position+=1)
  end

  def read_carbon(input, position)
    matcher = determine_position_bit_totals(input, position)
    filtered = []

    input.each { |i| filtered.push(i) if i[position] != matcher}

    return filtered[0] if filtered.length<=1
    read_carbon(filtered, position+=1)
  end

  oxygen = read_oxygen(input, 0)
  carbon = read_carbon(input, 0)

  oxygen.to_i(2) * carbon.to_i(2)
end

input = read_file_and_chomp("input.txt")

puts "#{read_power(input)}"
puts "#{read_life_support_rating(input)}"




