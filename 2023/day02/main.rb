# Advent of Code - Day x
require_relative '../../helpers'

DEBUG = true

def parse_line_to_hash(line)
  game = line.scan(/Game (\d+):/).first.first
  # puts 'Game is...'
  # p game
  # draws = line.scan(/\:([ \d\w,]+\;?)+/)
  draws = line.split(':')[1].split(';')
  draws_hash = [] 
  draws.each_with_index do |draw,idx|
    draw_hash={}
    dice_count = draw.scan(/((\d+) (\w+),?)/)
    dice_count.each do |die|
      # puts 'die is '
      # p die
      draw_hash[die[2]] = die[1]
    end
    draws_hash << draw_hash
  end
  # p draw_hash
  # puts 'draws are...'
  # puts draws
  [game,draws_hash]
end

def game_feasible?(draws, bag)
  draws.each do |draw|
    draw.keys.each do |color|
      return false if draw[color].to_i > bag[color]
    end
  end
  true
end

def silver(input)
  sum = 0
  bag = {
    'red' => 12,
    'green' => 13,
    'blue' => 14
  }
  input.each do |i|
    puts "Parsing line #{i}" if DEBUG
    game_and_hash =  parse_line_to_hash(i)
    sum += game_and_hash[0].to_i if game_feasible?(game_and_hash[1], bag)
  end

  sum
end

def gold(input)
  sum = 0
  input.each do |i|
    bag = {
      'red' => -1,
      'green' => -1,
      'blue' => -1
    }
    puts "Parsing line #{i}" if DEBUG
    game_and_hash = parse_line_to_hash(i)
    puts "Hash is #{game_and_hash[1]}"
    game_and_hash[1].each do |draw|
      draw.keys.each do |color|
        bag[color] = [bag[color], draw[color].to_i].max
      end
      p bag
    end
    p bag.values.inject(:*)
    sum += bag.values.inject(:*)
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
  else
    'example.txt'
  end
)

# puts "Silver: #{silver(@input)}"
puts "Gold: #{gold(@input)}"
