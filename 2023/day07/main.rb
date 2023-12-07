# Advent of Code - Day x
require_relative '../../helpers'

class Card
  def initialize(label)
    @label = label
  end

  def rank
    ranks = {
      'A' => 14,
      'K' => 13,
      'Q' => 12,
      'J' => 11,
      'T' => 10,
      '9' => 9,
      '8' => 8,
      '7' => 7,
      '6' => 6,
      '5' => 5,
      '4' => 4,
      '3' => 3,
      '2' => 2,
    }.freeze

    ranks[@label]

  end
  def inspect
    @label
  end
end

class Hand
  include Comparable

  attr_reader :cards
  attr_reader :bid

  def initialize(cards, bid)
    @cards = cards
    @bid = bid
  end

  def strength
    # p @cards
    # p @cards.map(&:rank).tally
    break_down = @cards.map(&:rank).tally.values.sort.reverse
    # p break_down
    
    return 6 if break_down[0] == 5
    return 5 if break_down[0] == 4
    return 4 if break_down[0] == 3 and break_down[1] == 2
    return 3 if break_down[0] == 3 
    return 2 if break_down[0] == 2 and break_down[1] == 2
    return 1 if break_down[0] == 2
    return 0 if break_down[0] == 1
    throw 'WTH'
  end

  def <=>(other)
    o_strength = other.strength

    return -1 if strength < o_strength
    return 1 if strength > o_strength

    # ah crap, we have to look at the real cards.
    o_cards = other.cards
    @cards.each_with_index do |card, idx|
      return -1 if card.rank < o_cards[idx].rank
      return 1 if card.rank > o_cards[idx].rank
    end

    return 0
  end
end

def silver(input)
  hands = []
  input.each do |i|
    parts = i.split(' ')
    cards = []
    parts[0].chars { |card| cards << Card.new(card) }
    hands << Hand.new(cards, parts[1].to_i)
  end

  puts "hands strength"
  hands.each {|h| p h.strength}

  puts
  puts "sorted hands strenght"
  hands.sort.each {|h| puts "#{h.strength} with cards #{h.cards}"}

  weighted_bids = hands.sort.map.with_index { |h, idx| h.bid * (idx+1) }

  weighted_bids.inject(:+)
end

def gold(input)
  return
  input.each do |i|
    puts i
  end

  'done'
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
