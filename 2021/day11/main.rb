# Advent of Code - Day 11
require_relative "../helpers"

def print_hash(points)
  for r in 0..9 do 
    for c in 0..9 do
      # puts "Looking for point #{r},#{c}"
      point = points.find{|p| p[:row]==r && p[:col]==c}
      # puts "trying to print point #{point}"
      print "#{point[:value]}".red if point[:value]==0
      print point[:value] unless point[:value]==0
    end
    puts
  end
end

def flash_point(point)
  point[:value]=0
  point[:flashed]=true
  point
end

def process(ia)
  points = []
  ia.each_with_index do |row, r_index|
    # puts "Parsing row #{row} with index #{r_index}"
    cols = row.split('').map(&:to_i)
    # puts "Parsed row to #{cols}"
    cols.each_with_index do |col, c_index|
      # puts "Pushing Point with #{r_index},#{c_index} and value #{col}"
      points.push({row: r_index, col: c_index, value: col, flashed:false})
    end
  end
  puts "----"
  puts "Starting Grid"
  print_hash(points)
  puts "----"

  flash_count=0

  # do increments
  # 100.times do |iteration|
  iteration = 0
  loop do
    points.map!{|p| p[:value]+=1; p}

    #perform flashes
    loop do
      points.filter{|p| p[:value]>9 && !p[:flashed]}.each do |to_flash|
        # puts "Flashing point #{to_flash}"
        flash_point(to_flash)
        flash_count+=1

        surround_points = points.filter do |p| 
          (to_flash[:row]-1..to_flash[:row]+1).include?(p[:row]) &&
            (to_flash[:col]-1..to_flash[:col]+1).include?(p[:col]) &&
            !p[:flashed]
        end

        # puts "Should also flash #{surround_points}"
        surround_points.each{|p| p[:value]+=1; p}
      end

      break if points.none?{|p| p[:value]>9 && !p[:flashed]}
    end

    # puts "----"
    # puts "Iteration #{iteration} Grid"
    # print_hash(points)
    # puts "----"

    iteration += 1
    break if points.all?{|p| p[:flashed]==true}
    
    # Reset having flashed
    points.map!{|p| p[:flashed]=false;p}
  end

  puts "----"
  puts "Last Grid"
  print_hash(points)
  puts "----"

  # flash_count
  iteration
end


p "#{process(read_file_and_chomp("input.txt"))}"
