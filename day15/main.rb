require 'benchmark'
# Advent of Code - Day x
require_relative "../helpers"
require_relative "focus"

def process(cave)
  position = [0,0]

  max_v = cave.sort_by{|k,v| v[:v]}.reverse.first[1][:v]
  max_h = cave.sort_by{|k,v| v[:h]}.reverse.first[1][:h]

  cave["0,0"][:visited] = true;
  cave["0,0"][:dist] = 0
  
  # print_cave("Cave", cave)
  current_cost = 0
  puts "Cave Length : #{cave.length}"

  loop do 
    # puts "Current Position for iteration #{position}"
    cv, ch = position
    break if ch == max_h && cv == max_v

    up = cave["#{cv-1},#{ch}"]
    down = cave["#{cv+1},#{ch}"]
    left = cave["#{cv},#{ch-1}"]
    right = cave["#{cv},#{ch+1}"]

    possibilities = [up,down,left,right].reject{|v|v.nil? || v[:visited]}
    possibilities.map! do |pos|
      if pos[:dist].nil? || (pos[:cost] + current_cost) < pos[:dist]
        pos[:dist] = pos[:cost] + current_cost 
        pos[:from] = position 
        pos[:in_q] = true
      end
      pos
    end

    if possibilities.length == 0
      move_to = cave
        .filter{ |k,c| c[:in_q] && !c[:visited]}
        .sort_by{|k,v| v[:dist]}
        .first[1]
      # p move_to
      # p move_to.first[1]
      # move_to = move_to.first[1]
    else
      # p possibilities
      move_to = possibilities.sort_by{|v| v[:dist]}.first
      # p move_to
    end

    move_to[:visited] = true
    position = [move_to[:v], move_to[:h]]
    current_cost = move_to[:dist]

    #print_cave("After iteration", cave)

  end
  puts "Found Ending position!!!!"
  #
  # print_path(cave, coords)
  print_path(cave, determine_current_path(cave, position))

  cave.find{|k,v|v[:v]==position[0]&&v[:h]==position[1]}[1][:dist]
end

## This is the real part
# cave = make_part_two_cave("test.txt")
cave = read_file_to_array_of_i("test.txt")
time = Benchmark.measure do
  p process(cave)
end
p time.real
