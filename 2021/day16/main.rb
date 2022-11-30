# Advent of Code - Day x
require_relative "../helpers"

def read_file_to_binary(file_path)
  line = File.readlines(file_path).map(&:chomp).first
  line.hex.to_s(2).rjust(line.size*4, '0')
end
def read_literal(input)
  bits = ""
  loop do
    indicator = input.slice!(0)
    last = indicator == "0" ? true : false
    bits += input.slice!(0..3)
    break if last==true
  end
  [bits.to_i(2), input]
end

def read_bit(input)
  puts "Currently Attempting to parse #{input}"

  version = input.slice!(0..2).to_i(2)
  type = input.slice!(0..2).to_i(2)

  puts "Version #{version} and type #{type}"

  content = 0

  case type
  when 4
    puts "Literal Number"
    content, input= read_literal(input)
    puts "Literal read #{content}"
  else
    puts "Operator"
    length_type = input.slice!(0)
    # puts "Operator Length Type #{length_type}"
    case length_type
    when "0"
      length = input.slice!(0..14).to_i(2)
      puts "Operator Length Type 0, with length #{length}"
      bit_input = input.slice!(0..length-1)
      built_packets = []
      loop do 
        new_content, bit_input = read_bit(bit_input)
        built_packets.push(new_content)
        break unless bit_input.to_i(2) > 0
      end
      content = produce_new_content(built_packets, type)
      puts "Operator-0 Result #{content}"
    when "1"
      length = input.slice!(0..10).to_i(2)
      puts "Operator Length Type 1, with length #{length}"
      new_content = []
      length.times do |iteration|
        single_content, input = read_bit(input)
        puts "Operator Length Type 1, Iteration #{iteration} read #{single_content}"
        new_content.push(single_content)
      end
      content = produce_new_content(new_content, type)
      puts "Operator-1 Result #{content}"
      else
        abort "Unknown Type That should never happen #{type}"
    end
  end
  [content, input]
end

def process(input)
  loop do 
    output, input = read_bit(input)
    # puts "Process Loop output is #{output} with remaining input #{input} and version sum #{version_sum}"
    # puts "Process Loop output is #{output} and version sum #{version_sum}"
    break unless input.to_i(2) > 0
  end
end

def produce_new_content(next_content, type)
  puts "Attempt to produce new content with #{next_content} #{type}"
  case type
  when 0 # Sum
    puts "producing sum"
    content = next_content.sum
    # puts "new content #{content}"
  when 1 # Product
    puts "producing product"
    content = next_content.reduce(:*)
    # puts "new content is #{content}"
  when 2 # Minimum
    puts "minimum"
    content = next_content.sort.first
  when 3 # maximum
    puts "max"
    content = next_content.sort.last
  when 5 # Gretaer Than
    puts "gt"
    content = next_content[0]>next_content[1] ? 1 : 0
  when 6 # Less than
    puts "lt"
    content = next_content[0]<next_content[1] ? 1 : 0
  when 7 # Equal To
    puts "eq"
    content = next_content[0]==next_content[1] ? 1 : 0
  else
    abort "Unknown produce_new_content Type #{type}"
  end

  content
end

puts "#{process(read_file_to_binary("input.txt"))}"
