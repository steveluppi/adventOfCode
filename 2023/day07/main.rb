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
      'J' => 1,
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
    tally =  @cards.map(&:rank).tally
    if tally.has_key? 1 and tally.length > 1
      # we have a joker to move around.
      num_of_jokers = tally[1]
      tally.delete(1)
      high_card = tally.sort.sort_by{|x|x[1]}.reverse.to_h.first[0]
      tally[high_card] += num_of_jokers
    end
    # p tally
    # break_down = @cards.map(&:rank).tally.values.sort.reverse
    break_down = tally.values.sort.reverse
    # p break_down
    # p tally.sort.first
    # p tally.sort.last
    
    return 6 if break_down[0] == 5
    return 5 if break_down[0] == 4
    return 4 if break_down[0] == 3 and break_down[1] == 2
    return 3 if break_down[0] == 3 
    return 2 if break_down[0] == 2 and break_down[1] == 2
    return 1 if break_down[0] == 2
    return 0 if break_down[0] == 1
    6
  end

  def <=>(other)
    # puts "Comparing #{self.to_s} to #{other.to_s}"
    # puts "  strength: #{self.strength} to #{other.strength}"
    o_strength = other.strength

    # puts "  return -1" if strength < o_strength
    return -1 if strength < o_strength
    # puts "  return 1" if strength > o_strength
    return 1 if strength > o_strength

    # ah crap, we have to look at the real cards.
    o_cards = other.cards
    @cards.each_with_index do |card, idx|
      return -1 if card.rank < o_cards[idx].rank
      return 1 if card.rank > o_cards[idx].rank
    end

    return 0
  end

  def inspect
    @cards
  end
  def to_s
    @cards
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

  # puts "hands strength"
  # hands.each {|h| p h.strength}

  # puts
  # puts "sorted hands strenght"
  # hands.sort.each {|h| puts "#{h.strength} with cards #{h.cards}"}

  weighted_bids = hands.sort.map.with_index { |h, idx| h.bid * (idx+1) }

  weighted_bids.inject(:+)
end

def gold(input)
  hands = []
  input.each do |i|
    break if i == 'stop'
    parts = i.split(' ')
    cards = []
    parts[0].chars { |card| cards << Card.new(card) }
    hands << Hand.new(cards, parts[1].to_i)
  end

  # hands.each {|h| puts "#{h.strength} with cards #{h.cards}"}
  # hands.each {|h| h.strength}
  # puts
  # puts "sorted hands strength"
  # hands.sort.each_with_index {|h,idx| puts "#{h.strength} with cards #{h.cards} at index #{idx} and bid #{h.bid} and overall #{h.bid * (idx+1)}"}

  weighted_bids = hands.sort.map.with_index { |h, idx| h.bid * (idx+1) }

  weighted_bids.inject(:+)
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
