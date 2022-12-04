# Advent of Code - Day 4
require_relative "../helpers"
require "set"

def silver(input)
  sum = 0
  for i in input
    left,right=i.split(',')
    p left, right
    lBeg,lEnd = left.split('-')
    rBeg,rEnd = right.split('-')
    lSet = Set.new(lBeg.to_i..lEnd.to_i)
    rSet = Set.new(rBeg.to_i..rEnd.to_i)
    p lSet, rSet
    p (lSet <= rSet or rSet <= lSet) ? "True" : "False"
    sum+=1 if (lSet <= rSet or rSet <= lSet)
  end

  sum
end

def gold(input)
  sum = 0
  for i in input
    left,right=i.split(',')
    p left, right
    lBeg,lEnd = left.split('-')
    rBeg,rEnd = right.split('-')
    lSet = Set.new(lBeg.to_i..lEnd.to_i)
    rSet = Set.new(rBeg.to_i..rEnd.to_i)
    p lSet, rSet
    # p (lSet <= rSet or rSet <= lSet) ? "True" : "False"
    sum+=1 if lSet.intersect? rSet
  end

  sum
end


# Main execution
@input = read_file_and_chomp(
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
