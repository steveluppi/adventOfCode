# Advent of Code - Day x
require_relative '../../helpers'

# RE = /(?=\d.+\d)(?>(\d).*(?(?=\d)(\d)|(.*(\d))))|(\d)/
RE = /(\d).*(?>(\d))|(\d)/
DEBUG = false

def silver(input)
  sum = 0

  input.each do |i|
    puts "Number: [#{number_for_line i}] from Line: [#{i}]" if DEBUG
    sum += number_for_line(i).to_i
  end

  sum
end

def number_for_line(line)
  line.scan(RE) do |match|
    match.compact!
    match << match[0] if match.length == 1
    return match.join
  end
end

def gold(input)
  sum = 0
  rep = /one|two|three|four|five|six|seven|eight|nine/
  input.each do |i|
    j = i.gsub(rep, 'one' => '1', 'two' => '2', 'three' => '3', 'four' => '4',
                    'five' => '5', 'six' => '6', 'seven' => '7', 'eight' => '8', 'nine' => '9')

    puts 'WTH'.red if j =~ rep

    # puts "Number: [#{number_for_line j}] trimmed line [#{j.gsub(/[a-z]/,'')}]from line [#{j}] originally [#{i}]" if DEBUG
    puts "[#{number_for_line j}] [#{j.gsub(/[a-z]/, '')}] [#{j}] [#{i}]" if DEBUG
    sum += number_for_line(j).to_i
  end
  sum
end

def string_to_num(str)
  stuff = {
    'one' => 1,
    'two' => 2,
    'three' => 3,
    'four' => 4,
    'five' => 5,
    'six' => 6,
    'seven' => 7,
    'eight' => 8,
    'nine' => 9
  }
  stuff[str] || str
end

def gold2(input)
  sum = 0
  input.each do |line|
    first = line.scan(/\d|one|two|three|four|five|six|seven|eight|nine/)[0]
    last = line.reverse.scan(/eno|owt|eerht|ruof|evif|xis|neves|thgie|enin|\d/)[0]

    last.reverse! if last.length > 1
    puts "[#{string_to_num(first)}#{string_to_num(last)}] #{string_to_num first}[#{first}] and #{string_to_num last}[#{last}] of #{line}" if DEBUG

    sum += (string_to_num(first).to_s + string_to_num(last).to_s).to_i
  end
  sum
end

# Main execution
@input = read_file_and_chomp(
  case ARGV[0]
  when 'silver'
    'silver.txt'
  when 'gold'
    'gold.txt'
  when 'first'
    'example_first.txt'
  when 'arthur'
    'arthur.txt'
  else
    'example.txt'
  end
)

puts "Silver: #{silver(@input)}"
puts "Gold: #{gold2(@input)}"
