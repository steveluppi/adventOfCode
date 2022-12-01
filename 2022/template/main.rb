# Advent of Code - Day x
require_relative "../helpers"


def process(input)
  for i in input
    puts i
  end


  "done"
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
