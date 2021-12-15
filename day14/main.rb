# Advent of Code - Day x
require_relative "../helpers"

def parse_start_and_key(input)
  # Remove blank lines
  input.reject!{|x|x.empty?}

  # First line is the polymer
  polymer = input.shift

  # Parse the sequence map
  sequence_map = input.reduce({}){|acc, seq| left, right = seq.split(" -> "); acc["#{left}"]=right; acc;}

  return [polymer, sequence_map]
end

def do_count(polymer)
  max_char = {count:0}
  min_char = {count:0}
  while !polymer.empty?
    # puts "Polymer Before #{polymer}"
    char = polymer[0]
    puts "counting #{char}"
    count = polymer.count(char)
    puts "found #{count}"
    if count > max_char[:count]
      max_char[:char] = char
      max_char[:count] = count
    end
    if count < min_char[:count] || min_char[:count]==0
      min_char[:char] = char
      min_char[:count] = count
    end
    polymer.gsub!(/#{char}/, '')
    # puts "Polymer After #{polymer}"
  end
  max_char[:count]-min_char[:count]
end

def process(input)
  polymer, sequence_map = parse_start_and_key(input)

  polymer_counts = {}

  for pos in (polymer.length-2).downto(0) do
    polymer_counts["#{polymer[pos..pos+1]}"] ||= 0
    polymer_counts["#{polymer[pos..pos+1]}"]+=1
  end
  puts "initial counts for polymer #{polymer}"
  p polymer_counts

  40.times do |iteration|
    puts "Iteration #{iteration}"
    new_counts = {}

    polymer_counts.each do |poly, count|
      puts "making a new poly count for #{poly}"
      mid = sequence_map["#{poly}"]
      left = poly[0]
      right = poly[1]
      puts "#{left}#{mid}#{right}"
      new_counts["#{left}#{mid}"] ||=0
      new_counts["#{mid}#{right}"] ||=0
      new_counts["#{left}#{mid}"] += count
      new_counts["#{mid}#{right}"] += count
    end

    p new_counts
    polymer_counts = new_counts
  end

  totals = {}
  polymer_counts.each do |poly, count|
    l = poly[0]
    r = poly[1]

    totals["#{l}"] ||= 0
    totals["#{l}"] += count
    # totals["#{r}"] ||= 0
    # totals["#{r}"] += count unless r==l
  end
  totals["#{polymer.slice(-1)}"]+=1
  p totals
  min, max = 0,0
  totals.each do |x,c|
    min = c if c<min || min == 0
    max = c if c > max
  end
  p min, max
  p max-min
  nil
end

def slow_process(input)
  polymer, sequence_map = parse_start_and_key(input)

  2.times do |iteration|
    puts "Iteration #{iteration}"
    for pos in (polymer.length-2).downto(0) do
      polymer.insert(pos+1, sequence_map["#{polymer[pos..pos+1]}"])
    end
  end

  p polymer
  p do_count(polymer)
end
puts "#{process(read_file_and_chomp("input.txt"))}"
# puts "#{slow_process(read_file_and_chomp("test.txt"))}"
