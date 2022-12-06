# Advent of Code - Day 6
require_relative "../helpers"

def silver(input)
  for i in input
    for j in 3..i.length
      p i[j-3..j].join if i[j-3..j]==i[j-3..j].uniq
      p j+1 if i[j-3..j]==i[j-3..j].uniq
      break if i[j-3..j]==i[j-3..j].uniq
    end
  end

  "done"
end

def gold(input)
  for i in input
    for j in 13..i.length
      p i[j-13..j].join if i[j-13..j]==i[j-13..j].uniq
      p j+1 if i[j-13..j]==i[j-13..j].uniq
      break if i[j-13..j]==i[j-13..j].uniq
    end
  end

  "done"
end


# Main execution
@input = read_file_to_array_of_single_char(
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
