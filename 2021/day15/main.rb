# Advent of Code - Day x
require_relative "../helpers"

def read_file_to_array_of_i(file_path)
  # File.readlines(file_path).map(&:chomp).map{|l| l.split("").map(&:to_i)}
  cave = {} 
  File.readlines(file_path).map(&:chomp).map.with_index do |line, index| 
    line.split("").map.with_index do |value, vi| 
      cave["#{index},#{vi}"] = {v:index, h:vi, cost:value.to_i, visited:false, dist:nil, from:nil, in_q:false}
    end
  end
  cave
end

def print_path(cave, coords)
  max_v = cave.sort_by {|k,v| v[:v]}.reverse.first[1][:v]
  max_h = cave.sort_by{|k,v| v[:h]}.reverse.first[1][:h]
  puts
  puts "-- Path --"
  for v in 0..max_v do
    for h in 0..max_h do
      print coords.include?([v,h]) ? "#" : "."
    end
    puts
  end
end
def print_cave(title, cave)
  return
  max_v = cave.sort_by {|k,v| v[:v]}.reverse.first[1][:v]
  max_h = cave.sort_by{|k,v| v[:h]}.reverse.first[1][:h]
  puts
  puts "-- #{title} --"
  for v in 0..max_v do
    for h in 0..max_h do
      print cave["#{v},#{h}"][:cost]
    end
    puts
  end
  puts "-- Visited --"
  for v in 0..max_v do
    for h in 0..max_h do
      print cave["#{v},#{h}"][:visited] ? "#" : ' ' 
    end
    puts
  end
  puts "-- Distanc3 --"
  for v in 0..max_v do
    for h in 0..max_h do
      print cave["#{v},#{h}"][:dist].nil? ? "#" : cave["#{v},#{h}"][:dist]
    end
    puts
  end
  puts "-----------"
  puts
end

def process(cave)
  position = [0,0]
  max_v = cave.sort_by {|k,v| v[:v]}.reverse.first[1][:v]
  max_h = cave.sort_by{|k,v| v[:h]}.reverse.first[1][:h]
  cave["0,0"][:visited] = true;
  cave["0,0"][:dist] = 0
  print_cave("Cave", cave)
  current_cost = 0

  loop do 
    puts "Current Position for iteration #{position}"
    cv, ch = position
    break if ch == max_h && cv == max_v
    up = cave["#{cv-1},#{ch}"]
    down = cave["#{cv+1},#{ch}"]
    left = cave["#{cv},#{ch-1}"]
    right = cave["#{cv},#{ch+1}"]
    # p up, down, left, right

    possibilities = [up,down,left,right].reject{|v|v.nil? || v[:visited]}
    possibilities.map do |pos|
      new_dist = pos[:cost] + current_cost
      if pos[:dist].nil? || new_dist < pos[:dist]
        pos[:dist] = new_dist 
        pos[:from] = position 
        pos[:in_q] = true
      end
      pos
    end
    queue = cave.filter{ |k,c| c[:in_q] }
    # p queue
    move_to = queue.reject{|k,v| v[:visited]}.sort_by{|k,v| v[:dist]}.first[1]
    move_to[:visited] = true
    position = [move_to[:v], move_to[:h]]
    current_cost = move_to[:dist]

    print_cave("After iteration", cave)

  end
  puts "Ending position!!!!"
  puts max_v, max_h
  # p position

  cost = 0
  coords = []
  loop do
    cv, ch = position
    break if cv==0 && ch==0
    step = cave.find{|k,v| v[:v]==cv && v[:h]==ch}[1]
    coords.push(step[:from])
    # p step
    cost += step[:cost]
    position = step[:from]
  end
  print_path(cave, coords)

  cost
end

def make_part_two_cave(filepath)
  file_lines = read_file_and_chomp(filepath)
  # cave["#{index},#{vi}"] = {v:index, h:vi, cost:value.to_i, visited:false, dist:nil, from:nil, in_q:false}
  cave = {}
  big_cave = []
  file_lines.each_with_index do |line, index|
    p line
    new_line = []
    5.times do |iteration|
      line.split('').each_with_index do |col, c_index|
        new_line.push(col.to_i+iteration)
      end
    end
    new_line.map!{|v| v>9 ? v-9 : v}
    p new_line
    big_cave.push(new_line)
  end

  bigger_cave = []
  4.times do |iter|
    bigger_cave.concat(big_cave.map{|l| l.map{|v| v+iter+1}})
  end
  bigger_cave.map!{|l| l.map!{|v| v>9 ? v-9 : v}}
  #p bigger_cave
  big_cave.each{|l| puts l.join("")}
  bigger_cave.each{|l| puts l.join("")}
  big_cave.concat(bigger_cave).each_with_index do |line, index|
    line.each_with_index do |value, vi|
      cave["#{index},#{vi}"] = {v:index, h:vi, cost:value.to_i, visited:false, dist:nil, from:nil, in_q:false}
    end
  end
  cave
end

# puts "#{process(read_file_to_array_of_i("input.txt"))}"
puts "#{process(make_part_two_cave("test.txt"))}"
