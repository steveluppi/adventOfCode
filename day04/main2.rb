# Advent of Code - Day x
require_relative "../helpers"

class String
  def red;            "\e[31m#{self}\e[0m" end
end

def parse_input(input)
  input_hash = {boards:[]}
  board_number = -1
  board_row = 0 
  input.each_index do |idx|
    if input[idx].empty?
      board_number+=1
      board_row=0
      next
    end
    input_hash[:number_draw] = input[idx].split(',') if idx == 0
    next if idx==0
    input_hash[:boards][board_number] = [] if input_hash[:boards][board_number].nil?
    input_hash[:boards][board_number][board_row] = input[idx].split(' ').map { |b| {number: b, marked: false}}
    board_row+=1
  end
  input_hash
end

def mark_board(board, draw)
  board.each do |row|
    row.each do |number| 
      number[:marked] = true if number[:number]==draw
    end
  end
  board
end

def print_board(board)
  board.each do |row|
    row.each do |num|
      print num[:number].red if num[:marked]
      print num[:number] if !num[:marked]
      print " "
    end
    puts
  end
end

def check_board(board)
  board.each do |row|
    return true if row.all? { |x| x[:marked]}
  end
  board.transpose.each do |row|
    return true if row.all? { |x| x[:marked]}
  end
  false
end

def play(input)
  parsed_input = parse_input(input)

  parsed_input[:number_draw].length.times do |iteration|
    draw = parsed_input[:number_draw].shift
    parsed_input[:boards].each { |b| b=mark_board(b, draw)}
    return {draw: draw, board:parsed_input[:boards][0]} if parsed_input[:boards].length==1 && check_board(parsed_input[:boards][0])
    parsed_input[:boards] = parsed_input[:boards].delete_if { |b| check_board(b) }
  end
end

def process(input)
  winner = play(input)
  puts "winning number: #{winner[:draw]}"
  puts "winning board:"
  print_board(winner[:board])

  unmarked_sum = 0
  winner[:board].each do |row|
    row.each {|n| unmarked_sum += n[:number].to_i if !n[:marked]}
  end
  unmarked_sum * winner[:draw].to_i
end

puts "Winning Sum: #{process(read_file_and_chomp("input.txt"))}"
