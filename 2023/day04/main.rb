# Advent of Code - Day x
require_relative '../../helpers'

def silver(input)
  total = 0
  input.each do |i|
    card = i.split(':')
    card_num = card[0].scan(/(\d)+/)
    card_content = card[1].split('|')
    winners = Set.new(card_content[0].split(' ').compact.map(&:to_i))
    my_numbers = Set.new(card_content[1].split(' ').compact.map(&:to_i))
    matches = winners & my_numbers
    puts "#{card_num.flatten[0]} wins #{matches}"
    points = 1 << matches.size-1
    total += points
  end

  total
end

def get_points_for_card(card)
    total = 0
    card_content = card.split('|')
    winners = Set.new(card_content[0].split(' ').compact.map(&:to_i))
    my_numbers = Set.new(card_content[1].split(' ').compact.map(&:to_i))
    matches = winners & my_numbers
    points = 1 << matches.size-1
    total += points
    total
end

def gold(input, range = 0..input.length, depth = 0)
  # exit if depth>10
  total_cards = 0
  # p input.slice(range)
  operating_input = input.slice(range)
  operating_input.each_with_index do |line, idx|
    card = line.split(':')
    card_num = card[0].scan(/(\d)+/)
    i_log("Checking card #{card_num.flatten[0]}", depth)
    total_cards += 1
    # puts "Processing card number: #{card_num}"
    card_content = card[1].split('|')
    # puts "  with card contents :#{card_content}"
    winners = Set.new(card_content[0].split(' ').compact.map(&:to_i))
    # puts "    winners #{winners}"
    my_numbers = Set.new(card_content[1].split(' ').compact.map(&:to_i))
    # puts "    my numbers #{my_numbers}"
    matches = winners & my_numbers
    i_log(" which won #{matches.size} cards", depth)
    # puts "    and matches #{matches}"

    i_log(" which is #{range.first + idx + 1..range.first + idx + matches.size} cards", depth)
    i_log("  => #{input.slice(range.first + idx + 1..range.first + idx + matches.size)}", depth)
    total_cards += gold(input, range.first + idx + 1..range.first + idx + matches.size, depth + 1)
  end

  total_cards
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

puts "Silver: #{silver(@input)}"
puts "Gold: #{gold(@input)}"
