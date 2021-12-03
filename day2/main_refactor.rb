# Advent of Code - Day 2
require_relative "../helpers"

def dive(input)
  location = {depth:0, distance:0}

  input.each do |movement| 
    direction, delta = movement.split(' ')
    delta = delta.to_i

    case direction
    when "up"
      location[:depth]-=delta
    when "down"
      location[:depth]+=delta
    when "forward"
      location[:distance]+=delta
    else 
      puts "Unknown Direction"
    end
  end

  location[:depth] * location[:distance]
end

def dive_with_aim(input)
  aim, depth, distance = 0,0,0

  input.each do |movement| 
    direction, delta = movement.split(' ')
    delta = delta.to_i

    case direction
    when "up"
      aim-=delta
    when "down"
      aim+=delta
    when "forward"
      distance+=delta
      depth+=(aim*delta)
    else 
      puts "Unknown Direction"
    end
  end

  depth * distance
end

puts "#{dive(read_file_and_chomp("input.txt"))}"
puts "#{dive_with_aim(read_file_and_chomp("input.txt"))}"
