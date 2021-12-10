# Advent of Code - Day x
require_relative "../helpers"

def parse_input(input)
  read_file_and_chomp(input).map {|l| l.split('').map(&:to_i)}
end

def print_map(input, points_of_interest)
  for r in 0..input.length-1 do
    for c in 0..input[r].length-1 do
      if points_of_interest.include?([r,c])
        print input[r][c].to_s.red
      else
        print input[r][c].to_s
      end
    end
    puts
  end
end

def process(input)
  low_points = []
  for r in 0..input.length-1 do
    for c in 0..input[r].length-1 do
      up=r==0 ? nil : input[r-1][c]
      down=r==input.length-1 ? nil : input[r+1][c]
      left=c==0 ? nil : input[r][c-1]
      right=c==input[r].length-1 ? nil : input[r][c+1]
      point = input[r][c]
      # puts
      # puts ".#{up}."
      # puts "#{left}#{point}#{right}"
      # puts ".#{down}."
      # puts

      low_points.push([r,c]) if (
         (up.nil? || point < up) &&
         (left.nil? || point < left) &&
         (right.nil? || point < right) &&
         (down.nil? || point < down) 
      )
    end
  end
  
  # print_map(input, low_points)
  risk_level_sum = low_points.reduce(0) do |memo, coord|
    r,c = coord
    memo += input[r][c]+1
    memo
  end
  puts "Risk Level Sum is #{risk_level_sum}"

  basins = low_points.map do |coord|
    poi = check_basin_coords(input, coord, [])
    poi
  end
  # basins.each {|b| print_map(input, b); puts}
  basins.map {|b| b.length}.sort.last(3).reduce(:*)
end

def check_basin_coords(input, coord, known_poi)
  known_poi.push(coord)
  r,c = coord

  up    = r == 0 ? nil : input[r-1][c]
  down  = r == input.length-1 ? nil : input[r+1][c]
  left  = c == 0 ? nil : input[r][c-1]
  right = c == input[r].length-1 ? nil : input[r][c+1]

  if !up.nil? && up != 9
    known_poi = check_basin_coords(input, [r-1,c], known_poi) unless known_poi.include?([r-1,c])
  end
  if !down.nil? && down != 9
    known_poi = check_basin_coords(input, [r+1,c], known_poi) unless known_poi.include?([r+1,c])
  end
  if !left.nil? && left != 9
    known_poi = check_basin_coords(input, [r,c-1], known_poi) unless known_poi.include?([r,c-1])
  end
  if !right.nil? && right != 9
    known_poi = check_basin_coords(input, [r,c+1], known_poi) unless known_poi.include?([r,c+1])
  end
  
  known_poi
end

puts "#{process(parse_input("input.txt"))}"
