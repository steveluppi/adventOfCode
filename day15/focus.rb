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
  # time = Benchmark.measure do 
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
  # end
  # print "print_path time "
  # puts time.real
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

def determine_current_path(cave, position)
  mapped_pos = position.clone
  coords = []
  # time = Benchmark.measure do
    loop do
      cv, ch = mapped_pos
      break if cv==0 && ch==0
      step = cave.find{|k,v| v[:v]==cv && v[:h]==ch}[1]
      coords.push(step[:from])
      mapped_pos = step[:from]
    end
  # end
  # print "determine_current_path time "
  # puts time.real

  coords
end

def make_part_two_cave(filepath)
  file_lines = read_file_and_chomp(filepath)
  # cave["#{index},#{vi}"] = {v:index, h:vi, cost:value.to_i, visited:false, dist:nil, from:nil, in_q:false}
  cave = {}
  big_cave = []
  file_lines.each_with_index do |line, index|
    new_line = []
    5.times do |iteration|
      line.split('').each_with_index do |col, c_index|
        new_line.push(col.to_i+iteration)
      end
    end
    new_line.map!{|v| v>9 ? v-9 : v}
    big_cave.push(new_line)
  end

  bigger_cave = []
  4.times do |iter|
    bigger_cave.concat(big_cave.map{|l| l.map{|v| v+iter+1}})
  end
  bigger_cave.map!{|l| l.map!{|v| v>9 ? v-9 : v}}
  #p bigger_cave
  # big_cave.each{|l| puts l.join("")}
  # bigger_cave.each{|l| puts l.join("")}
  big_cave.concat(bigger_cave).each_with_index do |line, index|
    line.each_with_index do |value, vi|
      cave["#{index},#{vi}"] = {v:index, h:vi, cost:value.to_i, visited:false, dist:nil, from:nil, in_q:false}
    end
  end
  cave
end

