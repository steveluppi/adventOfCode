# Advent of Code - Day x
require_relative "../helpers"

def parse_lines(input)
  parsed = []
  input.each do |line|
    pattern, value = line.split('|')
    parsed.push(pattern: pattern, value: value)
  end
  parsed
end

def parse_lines_with_array(input)
  parsed = []
  input.each do |line|
    pattern, value = line.split('|')
    parsed.push(pattern: pattern.split(), value: value)
  end
  parsed
end

def process(input)
  input_set = parse_lines(input)
  input_set.reduce(0) do |memo, set|
    memo += set[:value].split(' ').select {|n| [2,4,3,7].include? n.length}.length
  end
end

def determine_digit_pattern(input)
  input_set = parse_lines_with_array(input)
  # input_set = parse_lines_with_array(['be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe'])
  # input_set = parse_lines_with_array(['acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf'])
  p input_set

  outputs = []
  input_set.each do |set|
    wires = []
    vals = set[:pattern].map {|v| v.split('')}

    one = vals.select { |v| v.length == 2 }.flatten
    four = vals.select { |v| v.length == 4 }.flatten
    seven = vals.select { |v| v.length == 3 }.flatten
    eight = vals.select { |v| v.length == 7 }.flatten

    puts "Known Numbers: "
    puts "one"
    p one
    puts "four"
    p four
    puts "seven"
    p seven
    puts "eight"
    p eight
    puts

    wires[0] = (seven - one).pop
    puts "Wire 0; #{wires[0]}"
    puts

    len_six = vals.select { |v| v.length == 6}

    nine = len_six.select {|v| (v-four-seven).length==1}.flatten
    puts "nine"
    p nine
    puts
    len_six.reject! { |v| v == nine}

    wires[6] = (nine-four-seven).pop
    puts "Wire 6: #{wires[6]}"
    puts

    wires[4] = (len_six.first-nine).pop
    puts "Wire 4: #{wires[4]}"
    puts

    zero = len_six.select { |v| (v-one).length < v.length-1}.flatten
    six = len_six.select { |v| (v-one).length == v.length-1}.flatten
    puts "Zero"
    p zero
    puts
    puts "Six"
    p six
    puts
    wires[3] = (eight-zero).pop
    puts "Wire 3: #{wires[3]}"
    puts

    len_five = vals.select {|v| v.length==5}

    two = len_five.select {|v| (v-wires).length==1}.flatten
    puts "Two"
    p two
    puts
    wires[2] = (two-wires).pop
    puts "Wire 2: #{wires[2]}"
    puts

    wires[5] = (one-wires).pop
    puts "Wire 5: #{wires[5]}"
    puts

    wires[1] = (eight-wires).pop
    puts "Wire 1: #{wires[1]}"
    puts

    p wires
    actual_numbers = [
      zero,
      one,
      two,
      [wires[0], wires[2], wires[3], wires[5], wires[6]],
      four,
      [wires[0], wires[1], wires[3], wires[5], wires[6]],
      six,
      seven,
      eight,
      nine
    ]
    p actual_numbers
    numbers = set[:value].split()
    readout = ""
    numbers.each do |num|
      num_set = num.split('')
      actual_numbers.each_with_index do |an, idx|
        readout+=idx.to_s if (an|num_set).length == (an&num_set).length
      end
    end
    puts readout
    outputs.push(readout)
  end
  p outputs
  p outputs.reduce(0){|m,v|m+=v.to_i}
end

# puts "#{process(read_file_and_chomp("test.txt"))}"
determine_digit_pattern(read_file_and_chomp("input.txt"))
