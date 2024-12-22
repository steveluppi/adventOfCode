# Advent of Code - Day x
require_relative "../helpers"

def read_file_to_packet_pairs(filename)
  lines = File.readlines(filename).map(&:chomp)
  packets=[]
  idx=0
  for l in lines
    idx+=1 if l.empty?
    break if idx>0
    packets[idx] ||= []
    puts "Parsing packet #{l}"
    puts l.empty?
    puts "Adding #{parse_packet(l)} to index #{idx}" unless l.empty?
    packets[idx] << parse_packet(l) unless l.empty? 
    puts "Packets iteration #{packets}"
  end

  p packets
end

def parse_packet(packet)
  packet = []
  for a in packet.split(',')
    puts a
  end
  nil
end
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
@input = read_file_to_packet_pairs(
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
# puts "Gold: #{gold(@input)}"
