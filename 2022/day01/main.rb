# Advent of Code - Day 1
require_relative "../helpers"

def silver(input)
  biggest=0
  sum=0
  for line in input
    if line.empty?
      biggest = sum if sum>biggest
      sum=0
      next
    end
    sum+=line.to_i
  end

  biggest
end

def gold(input)
  sums=[]
  sum=0

  for line in input
    if line.empty?
      sums.append(sum);
      sum=0
      next
    end
    sum+=line.to_i
  end
  sums.append(sum)

  sums.sort!.reverse!
  
  sum=0
  for i in 0..2
    sum += sums[i]
  end

  sum
end

# Main execution
@input = read_file_and_chomp(
  case ARGV[0]
  when "second"
    "second.txt"
  when "first"
    "first.txt"
  else
    "example.txt"
  end
)

puts "#{silver(@input)}"
puts "#{gold(@input)}"
