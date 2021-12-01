total = 0
File.foreach("input.txt") { |line| total+=line.to_i}
puts total
