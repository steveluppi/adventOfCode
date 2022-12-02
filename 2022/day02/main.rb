# Advent of Code - Day 2
require_relative "../helpers"

def applyStrategy(opponent, desiredResult)
  case opponent
  when "A" # Rock
    return "Z" if desiredResult == "X" # Lose
    return "X" if desiredResult == "Y" # Draw
    return "Y" if desiredResult == "Z" # Win
  when "B" # Paper
    return "X" if desiredResult == "X" # Lose
    return "Y" if desiredResult == "Y" # Draw
    return "Z" if desiredResult == "Z" # Win
  when "C" # Scissors
    return "Y" if desiredResult == "X" # Lose
    return "Z" if desiredResult == "Y" # Draw
    return "X" if desiredResult == "Z" # Win
  end
end

def did_i_win(opponent, you)
  case opponent
  when "A"
    you=="Y" ? 6 : you=="X" ? 3 : 0
  when "B"
    you=="Z" ? 6 : you=="Y" ? 3 : 0
  when "C"
    you=="X" ? 6 : you=="Z" ? 3 : 0
  end
end

def my_hand_score(you)
  case you
  when "X"
    1
  when "Y"
    2
  when "Z"
    3
  end
end

def scoreRound(opponent, you)
  p "did I win"
  p did_i_win(opponent, you)
  p "and my score"
  p my_hand_score(you)
  did_i_win(opponent, you) + my_hand_score(you)
end


def silver(input)
  # puts "input #{input}"
  # puts "input length #{input.length}"
  sum = 0
  for i in input
    # p i 
    sum += scoreRound(i[0],i[1])
  end

  sum
end

def gold(input)
  sum = 0
  for i in input
    puts "Strat for #{i} is #{applyStrategy(i[0],i[1])}"
    sum += scoreRound(i[0], applyStrategy(i[0],i[1]))
  end
  sum
end


# Main execution
# @input = read_file_and_chomp(
@input = read_file_to_pairs(
  case ARGV[0]
  when "silver"
    "silver.txt"
  when "gold"
    "gold.txt"
  else
    "example.txt"
  end
)

puts "Silver: #{silver(@input)}"
puts "Gold: #{gold(@input)}"
