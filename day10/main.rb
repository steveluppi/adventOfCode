# Advent of Code - Day 10
require_relative "../helpers"

def process(input)
  line_scores = input.map {|line| determine_line_score(line)}.reject(&:nil?)
  line_scores.map!{|l| calculate_auto_complete_score(l)}.sort.at((line_scores.length / 2.0).floor)
end

def calculate_auto_complete_score(line)
  puts "calculating line #{line}"
  score = 0
  loop do 
    case line.pop
    when '('
      score = score * 5 + 1
    when '['
      score = score * 5 + 2
    when '{'
      score = score * 5 + 3
    when '<'
      score = score * 5 + 4
    end
      break if line.length==0
  end
  puts "score is #{score}"
  score
end

def is_open?(char)
  /\(|\{|\[|\</.match?(char)
end

def is_close?(char)
  /\)|\}|\]|\>/.match?(char)
end

def is_pair?(pair)
  /\(\)|\{\}|\[\]|\<\>/.match?(pair)
end

def determine_line_score(line)
  stack = []
  puts
  puts "checking line #{line.join()}"
  line.each do |char|
    puts "Checking #{char} against #{stack}"
    if is_open?(char)
      puts "Is open char, push onto stack"
      stack.push(char) 
    elsif is_pair?("#{stack.last}#{char}")
      puts "Is pair, pop from stack"
      stack.pop() 
    else
      puts "Line is corrupt..."
      return nil
    end
  end
  stack
end

puts "#{process(read_file_to_array_of_single_char("input.txt"))}"
