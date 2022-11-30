# Advent of Code - Day 1

def sweep(input)
  last_depth = NIL
  depth_increase_count = 0

  input.each do |depth|
    if last_depth.nil?
      puts "#{depth} (N/A - no previous measurement)"
    else
      puts "#{depth} (#{depth.to_i > last_depth.to_i ? "Increased" : "Decreased"})"
      depth_increase_count+=1 if depth.to_i > last_depth.to_i
    end
    last_depth = depth
  end

  puts

  # Return
  depth_increase_count
end

def sliding_window(input)
  wa = []

  p input
  input.each_with_index do |depth, index|
    next if index < 2
    wa.push(depth.to_i + input[index-1].to_i + input[index-2].to_i)
  end

  wa
end

puts "#{sweep(File.read("input.txt").split.each {|l| l.gsub("\n","")})} Increases occur"
puts "#{sweep(sliding_window(File.read("input.txt").split))} Increases occur with a sliding window"
# p sliding_window(File.read("input2.txt").split)
