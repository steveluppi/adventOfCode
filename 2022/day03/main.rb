# Advent of Code - Day 3
require 'set'
require_relative "../helpers"

def silver(input)
  alpha="0abcdefghijklmnopqrstuvwxyz"
  sum=0
  for i in input
    left = i.slice(0,i.length/2)
    right = i.slice(i.length/2..)
    leftSet = Set.new(left.split(''))
    rightSet = Set.new(right.split(''))
    puts left
    puts right
    p leftSet
    p rightSet
    p leftSet&rightSet
    intersect =leftSet&rightSet
    for j in intersect
      p alpha.index(j.downcase)
      sum+= alpha.index(j.downcase)
      sum+=26 unless j.downcase == j
    end
  end

  sum
end

def gold(input)
  alpha="0abcdefghijklmnopqrstuvwxyz"
  sum=0
  0.step(input.length-1,3) do |idx|
    puts "Group #{idx}"
    first = Set.new(input[idx].split(""))
    second = Set.new(input[idx+1].split(""))
    third = Set.new(input[idx+2].split(""))
    p first&second&third
    for j in first&second&third
      p alpha.index(j.downcase)
      sum+= alpha.index(j.downcase)
      sum+=26 unless j.downcase == j
    end
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
