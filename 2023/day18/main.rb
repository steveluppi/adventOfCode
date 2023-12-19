require_relative '../../helpers'
require 'io/console'
require 'set'

class Location
  attr_reader :row, :col, :color

  def initialize(x, y, color=nil)
    @row = x
    @col = y
    @color = color
  end

  def coords
    [@row, @col]
  end
  
  def is?(check)
    x,y = check
    x==@row && y==@col
  end

  def graphic
    lines = {
      '|' => '│',
      '-' => '─',
      '7' => '╮',
      'F' => '╭',
      'J' => '╯',
      'L' => '╰',
      '.' => '•',
      'O' => '•',
      'I' => '•',
    }
    # lines[@label] || @label.red
    ''
  end

  def inspect
    "Location [#{@row}, #{@col}]"
  end

  def to_s
    "Location [#{@row}, #{@col}]"
  end
end

class AOC
  def self.parse_field(lines)
    max_row, max_col = [0, 0]
    min_row, min_col = [0, 0]
    curr_x, curr_y = [0, 0]
    field = Set.new
    # field << Location.new(0,0,'???')
    lines.each do |line|
      direction, steps, color = line.scan(/(.) (\d+) \(\#([0-9a-f]+)\)/).flatten

      # puts "Moving #{steps} #{direction} with color #{color}"

      case direction
      when 'U'
        (1..steps.to_i).each do |s|
          curr_x -= 1
          field << Location.new(curr_x, curr_y, color)
        end
      when 'D'
        (1..steps.to_i).each do |s|
          curr_x += 1
          field << Location.new(curr_x, curr_y, color)
        end
      when 'L'
        (1..steps.to_i).each do |s|
          curr_y -= 1
          field << Location.new(curr_x, curr_y, color)
        end
      when 'R'
        (1..steps.to_i).each do |s|
          curr_y += 1
          field << Location.new(curr_x, curr_y, color)
        end
      end
      
      #store new maxs and mins?
      max_row = [max_row, curr_x].max
      max_col = [max_col, curr_y].max

      min_row = [min_row, curr_x].min
      min_col = [min_col, curr_y].min
    end

    [min_row, max_row, min_col, max_col, field]
  end
  def self.parse_field_gold(lines)
    max_row, max_col = [0, 0]
    min_row, min_col = [0, 0]
    curr_x, curr_y = [0, 0]
    field = Set.new
    # field << Location.new(0,0,'???')
    lines.each do |line|
      direction, steps = line

      # puts "Moving #{steps} #{direction} with color #{color}"

      case direction
      when 'U'
        (1..steps.to_i).each do |s|
          curr_x -= 1
          field << Location.new(curr_x, curr_y)
        end
      when 'D'
        (1..steps.to_i).each do |s|
          curr_x += 1
          field << Location.new(curr_x, curr_y)
        end
      when 'L'
        (1..steps.to_i).each do |s|
          curr_y -= 1
          field << Location.new(curr_x, curr_y)
        end
      when 'R'
        (1..steps.to_i).each do |s|
          curr_y += 1
          field << Location.new(curr_x, curr_y)
        end
      end
      
      #store new maxs and mins?
      max_row = [max_row, curr_x].max
      max_col = [max_col, curr_y].max

      min_row = [min_row, curr_x].min
      min_col = [min_col, curr_y].min
    end

    [min_row, max_row, min_col, max_col, field]
  end

  def self.silver(lines)
    min_row, max_row, min_col, max_col, field = parse_field lines

    puts "Min row is #{min_row}"
    puts "Max row is #{max_row}"
    puts "Min col is #{min_col}"
    puts "Max col is #{max_col}"
    puts "field size is #{field.size}"
    field.select {|l| l.row == min_row }.each {|l| p l}

    # start = Location.new(-226, -122)
    start = Location.new(1,1)

    visited = Set.new
    current = Set[start.coords]

    while current.size > 0
      puts "Current depth is #{current.size} with visted being #{visited.size}"
      # mark all current locations as visitd.
      current.each do |c|
        visited << c
        in_field = field.find {|l| l.is? c}
        if in_field.nil?
          # puts "  and is not in the field so lets add it"
          x,y = c
          field << Location.new(x,y)
        end
      end

      new_current = Set.new

      current.each do |c|
        x,y = c
        # puts "Current coords are #{x} and #{y}"
        north_to = [x-1, y]
        south_to = [x+1, y]
        east_to = [x, y+1]
        west_to = [x, y-1]
        # p north_to, south_to, east_to, west_to

        north = field.find {|l| l.is? north_to}
        south = field.find {|l| l.is? south_to}
        east = field.find {|l| l.is? east_to}
        west = field.find {|l| l.is? west_to}

        x,y = north_to
        new_current << [x,y] if x>min_row and x <max_row and y>min_col and y<max_col and north.nil? and !visited.include? [x,y]
        x,y = south_to
        new_current << [x,y] if x>min_row and x <max_row and y>min_col and y<max_col and south.nil? and !visited.include? [x,y]
        x,y = east_to
        new_current << [x,y] if x>min_row and x <max_row and y>min_col and y<max_col and east.nil? and !visited.include? [x,y]
        x,y = west_to
        new_current << [x,y] if x>min_row and x <max_row and y>min_col and y<max_col and west.nil? and !visited.include? [x,y]
      end

      current = new_current
    end

    (min_row..max_row).each do |row|
      (min_col..max_col).each do |col|
        loc = field.find { |l| l.is?([row, col]) }
        print loc.nil? ? '•'.red : '#'.green
      end
      puts
    end

    field.select {|l| l.color.nil? }.size
    field.length
  end

  def self.silver_boxes(lines)
    max_row, max_col = [0, 0]
    min_row, min_col = [0, 0]
    curr_x, curr_y = [0, 0]
    field = Set.new
    field << [0,0]
    p = 0
    # field << Location.new(0,0,'???')
    lines.each do |line|
      p line
      direction, steps, color = line.scan(/(.) (\d+) \(\#([0-9a-f]+)\)/).flatten

      # puts "Moving #{steps} #{direction} with color #{color}"

      p += steps.to_i
      case direction
      when 'U'
        curr_x -= steps.to_i
      when 'D'
        curr_x += steps.to_i
      when 'L'
        curr_y -= steps.to_i
      when 'R'
        curr_y += steps.to_i
      end
      
      field << [curr_x, curr_y]

      #store new maxs and mins?
      max_row = [max_row, curr_x].max
      max_col = [max_col, curr_y].max

      min_row = [min_row, curr_x].min
      min_col = [min_col, curr_y].min
    end
    puts "field"
    p field

    vertices = []
    fa = field.to_a
    (0..fa.length-2).each do |idx|
      a = fa[idx]
      b = fa[idx+1]
      
      puts "looking at #{a} and #{b}"

      x1,y1 = a
      x2,y2 = b

      vertices << ((x1*y2)-(x2*y1))
    end
    first = fa.last
    last = fa.first
    puts "looking at #{first} and #{last}"
    x1,y1 = first
    x2,y2 = last
    vertices << ((x1*y2)-(x2*y1))
    p vertices

    a = 0.5 * vertices.inject(:+).abs
    a += (p/2) + 1
    puts "area #{a}"
    puts "field length #{fa.length}"
    puts "vertices length #{vertices.length}"
    # [min_row, max_row, min_col, max_col, field]

    a
  end

  def self.gold_boxes(lines)
    max_row, max_col = [0, 0]
    min_row, min_col = [0, 0]
    curr_x, curr_y = [0, 0]
    field = Set.new
    field << [0,0]
    p = 0
    # field << Location.new(0,0,'???')
    lines.each do |line|
      p line
      # direction, steps, color = line.scan(/(.) (\d+) \(\#([0-9a-f]+)\)/).flatten
      direction, steps = line
      # puts "Moving #{steps} #{direction} with color #{color}"

      p += steps.to_i
      case direction
      when 'U'
        curr_x -= steps.to_i
      when 'D'
        curr_x += steps.to_i
      when 'L'
        curr_y -= steps.to_i
      when 'R'
        curr_y += steps.to_i
      end
      
      field << [curr_x, curr_y]

      #store new maxs and mins?
      max_row = [max_row, curr_x].max
      max_col = [max_col, curr_y].max

      min_row = [min_row, curr_x].min
      min_col = [min_col, curr_y].min
    end
    puts "field"
    p field

    vertices = []
    fa = field.to_a
    (0..fa.length-2).each do |idx|
      a = fa[idx]
      b = fa[idx+1]
      
      puts "looking at #{a} and #{b}"

      x1,y1 = a
      x2,y2 = b

      vertices << ((x1*y2)-(x2*y1))
    end
    first = fa.last
    last = fa.first
    puts "looking at #{first} and #{last}"
    x1,y1 = first
    x2,y2 = last
    vertices << ((x1*y2)-(x2*y1))
    p vertices

    a = 0.5 * vertices.inject(:+).abs
    a += (p/2) + 1
    puts "area #{a}"
    puts "field length #{fa.length}"
    puts "vertices length #{vertices.length}"
    # [min_row, max_row, min_col, max_col, field]

    a
  end

  def self.gold(lines)
    lines.map! do |line|
      distance, direction_code = line.scan(/\#([0-9a-f]{5})(\d)/).flatten

      direction = "?"
      direction = case direction_code
                  when '0'
                    'R'
                  when '1'
                    'D'
                  when '2'
                    'L'
                  when '3'
                    'U'
                  end


      puts "Need to go #{direction} #{distance.to_i(16)} based on #{line}"
      [direction, distance.to_i(16)]
    end
    # min_row, max_row, min_col, max_col, field = parse_field_gold lines
    # p min_row, max_row, min_col, max_col, field.size

    # (0..10).each do |row|
    #   points = field.select { |l| l.row == row }
    #   p points
    # end
    gold_boxes lines
  end
end
