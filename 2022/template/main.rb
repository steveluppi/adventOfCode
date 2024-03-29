# Advent of Code - Day x
require_relative "../helpers"

def silver(input)
  for i in input
    puts i
  end

  "done"
end

def gold(input)
  for i in input
    puts i
  end

  "done"
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
