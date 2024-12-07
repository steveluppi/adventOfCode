require_relative '../../helpers'
require 'io/console'
require 'set'

class Location
  attr_reader :letter
  attr_reader :x
  attr_reader :y

  def initialize(letter, x, y)
    @letter = letter
    @x = x
    @y = y
  end
  
  def inspect
    "#{@letter} => #{@x}, #{@y}"
  end
  def to_s
    "#{@letter} => #{@x}, #{@y}"
  end
end

class AOC
  def self.look_around loc
    puts "time to look around #{loc}"

    around = []
    if loc.length == 2
      # we must have an X...let's look around.
      x,y = loc
      around << [x-1, y-1, 'M', 0] if $grid[x-1][y-1] == 'M' and x-1 >= 0 and y-1 >= 0
      around << [x-1, y+0, 'M', 1] if $grid[x-1][y+0] == 'M' and x-1 >= 0
      around << [x-1, y+1, 'M', 2] if $grid[x-1][y+1] == 'M' and x-1 >= 0 and y+1 <= $max_y
      around << [x+0, y-1, 'M', 3] if $grid[x+0][y-1] == 'M' and y-1 >= 0
      around << [x+0, y+1, 'M', 4] if $grid[x+0][y+1] == 'M' and y+1 <= $max_y
      around << [x+1, y-1, 'M', 5] if x+1 <= $max_x and y-1 >= 0 and $grid[x+1][y-1] == 'M' 
      around << [x+1, y+0, 'M', 6] if x+1 <= $max_x and $grid[x+1][y+0] == 'M' 
      around << [x+1, y+1, 'M', 7] if x+1 <= $max_x and y+1 <= $max_y and $grid[x+1][y+1] == 'M'
    else
      # we must have an M or an A...let's look around.
      x,y,l,c = loc
      case c
      when 0
        around << [x-1, y-1, 'A', 0] if l == 'M' and x-1 >= 0 and y-1 >= 0 and $grid[x-1][y-1] == 'A' 
        $total += 1 if l == 'A' and x-1 >= 0 and y-1 >= 0 and $grid[x-1][y-1] == 'S'
      when 1
        around << [x-1, y+0, 'A', 1] if l == 'M' and x-1 >= 0 and $grid[x-1][y+0] == 'A'
        $total += 1 if l == 'A' and x-1 >= 0 and $grid[x-1][y-0] == 'S'
      when 2
        around << [x-1, y+1, 'A', 2] if l == 'M' and x-1 >= 0 and y+1 <= $max_y and $grid[x-1][y+1] == 'A' 
        $total +=1 if l == 'A' and x-1 >= 0 and y+1 <= $max_y and $grid[x-1][y+1] == 'S'
      when 3
        around << [x+0, y-1, 'A', 3] if l == 'M' and y-1 >= 0 and $grid[x+0][y-1] == 'A'
        $total +=1 if l == 'A' and y-1 >= 0 and $grid[x+0][y-1] == 'S'
      when 4
        around << [x+0, y+1, 'A', 4] if l == 'M' and y+1 <= $max_y and $grid[x+0][y+1] == 'A'
        $total += 1 if l == 'A' and y+1 <= $max_y and $grid[x+0][y+1] == 'S'
      when 5
        around << [x+1, y-1, 'A', 5] if l == 'M' and x+1 <= $max_x and y-1 >= 0 and $grid[x+1][y-1] == 'A'
        $total +=1 if l == 'A' and x+1 <= $max_x and y-1 >= 0 and $grid[x+1][y-1] == 'S'
      when 6
        around << [x+1, y+0, 'A', 6] if l == 'M' and x+1 <= $max_x and $grid[x+1][y+0] == 'A'
        $total +=1 if l == 'A' and x+1 <= $max_x and $grid[x+1][y+0] == 'S'
      when 7
        around << [x+1, y+1, 'A', 7] if l == 'M'and x+1 <= $max_x and y+1 <= $max_y and $grid[x+1][y+1] == 'A' 
        $total +=1 if l == 'A' and x+1 <= $max_x and y+1 <= $max_y and $grid[x+1][y+1] == 'S'
      end
    end
    p around
    around
  end

  def self.simple(lines)
    lines.map! {|l| l.split('')}
    $grid = lines
    $max_x = lines.length-1
    $max_y = lines[0].length-1
    $total = 0
    
    q = []

    lines.each_with_index do |line, x_idx|
      # puts "line #{x_idx}"
      s = StringScanner.new(line.join)

      loop do
        val = s.scan_until(/X/)
        break if val.nil?
        q << [x_idx, s.pos-1]
      end
    end

    p q
    loop do
      work = q.shift
      puts "working on #{work}"

      surroundings = AOC.look_around work
      puts "which found #{surroundings}"

      q.concat(surroundings)

      break if q.empty?
    end

    $total
  end

  def self.silver(lines)
    grid = []
    $max_row = input.length
    $max_col = input[0].length

    lines.each_with_index do |line, x_idx|
      line.split('').each_with_index do |char, y_idx|
        grid << Location.new(char, x_idx, y_idx)
      end
    end
    p grid
  end

  def self.gold(lines)
    lines.map! {|l| l.split('')}
    $grid = lines
    $max_x = lines.length-1
    $max_y = lines[0].length-1
    $total = 0
    
    q = []

    lines.each_with_index do |line, x_idx|
      s = StringScanner.new(line.join)

      loop do
        val = s.scan_until(/A/)
        break if val.nil?
        q << [x_idx, s.pos-1]
      end
    end

    p q
    loop do
      work = q.shift
      puts "working on #{work}"

      $total +=1 if AOC.is_mas? work

      break if q.empty?
    end

    $total
  end

  def self.is_mas? loc
    x,y = loc
    return false if x-1 < 0 or x+1 > $max_x or y-1 < 0 or y+1 > $max_y

    s1 = "#{$grid[x-1][y-1]}#{$grid[x+1][y+1]}"
    s2 = "#{$grid[x+1][y-1]}#{$grid[x-1][y+1]}"

    return true if (s1 == "MS" or s1 == "SM") and (s2 == 'MS' or s2 == 'SM')
    false
  end
end
