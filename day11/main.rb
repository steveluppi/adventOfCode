# Advent of Code - Day 11
require_relative "../helpers"

def print_map(input)
  for r in 0..input.length-1 do
    for c in 0..input[r].length-1 do
      if input[r][c] == 0
        print input[r][c].to_s.red
      else
        print input[r][c].to_s
      end
    end
    puts
  end
end
def print_hash(points)
  for r in 0..9 do 
    for c in 0..9 do
      # puts "Looking for point #{r},#{c}"
      point = points.find{|p| p[:row]==r && p[:col]==c}
      # puts "trying to print point #{point}"
      print point[:value]
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

  # do increments
  2.times do |iteration|
    points.map!{|p| p[:value]+=1; p}

    #perform flashes
    loop do
      points.filter{|p| p[:value]>9 && !p[:flashed]}.each do |to_flash|
        puts "Flashing point #{to_flash}"
        flash_point(to_flash)
        surround_points = points.filter do |p| 
          [to_flash[:row]-1..to_flash[:row]+1].include?(p[:row]) &&
            [to_flash[:col]-1..to_flash[:col]+1].include?(p[:col]) &&
            !p[:flashed]
        end

        puts "Should also flash #{surround_points}"
      end

      break if true
      break if points.none?{|p| p[:value]>9 && !p[:flashed]}
    end

  end
  puts "----"
  puts "Ending Grid"
  print_hash(points)
  puts "----"

  "Done"
end

def old_process(ia)
  # convert input to hash
  ia.map! {|l| l.map(&:to_i)}
  p ia

  flashes = 0
  1.times do |iteration|
    ia.map!{|r| r.map!(&:next)}

    for r in 0..ia.length-1 do 
      puts "Row #{r}"
      for c in 0..ia[r].length-1 do
        puts "Column #{c}"
      end
    end
    flashes = ia.reduce(flashes) do |memo, r|
      puts "Checking Row #{r}"
      memo += r.reduce(0) do |m, c|
        puts "Checking if #{c} is > 9"
        m+=1 if c > 9
        m
      end
      memo
    end
    puts "Flashes now at #{flashes}"
    ia.map!{|r| r.map!{|c| c>9 ? 0 : c}}
  end

  print_map(ia)

  ia
end

p "#{process(read_file_and_chomp("test.txt"))}"
