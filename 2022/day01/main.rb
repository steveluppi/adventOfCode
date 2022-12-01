# Advent of Code - Day x
require_relative "../helpers"


def process(input)
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

puts "#{process(@input)}"
