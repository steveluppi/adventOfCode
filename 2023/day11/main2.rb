require 'io/console'

class Location
  attr_accessor :row
  attr_accessor :col
  attr_accessor :label
  attr_accessor :seen

  def initialize(x,y, label)
    @row= x
    @col = y
    @label = label
    @seen = false
  end

  def coords
    [@row, @col]
  end

  def is?(r, c)
    @row==r && @col==c
  end

  def is_galaxy?
    @label != '.'
  end

  def north_to
    [@row-1, @col]
  end

  def south_to
    [@row+1, @col]
  end

  def west_to
    [@row, @col-1]
  end

  def east_to
    [@row, @col+1]
  end

  def inspect
    "#{@label} at #{@row}, #{@col}"
  end

  def to_s
    "#{@label} at #{@row}, #{@col}"
  end
end

class Day11
  def self.parse(raw)
    lines = raw.split
    bigger = []
    lines.each do |line|
      bigger << line.chars
      bigger << line.chars if line.chars.all? {|c| c == '.'}
    end
    bigger = bigger.transpose
    biggest = []
    bigger.each do |line|
      biggest << line
      biggest << line if line.all? {|c| c == '.'}
    end
    biggest = biggest.transpose
    biggest.map { |ra| ra.join }
  end
  
  def self.make_map(input)
    count=1
    map = []
    input.each_with_index do |row, row_index|
      row.chars.each_with_index do |col, col_index|
        map << Location.new(row_index, col_index, col == '#' ? count.to_s : col)
        count +=1 if col == '#'
      end
    end
    map
  end

  def self.path_between(map, from, to)
    shortest = nil
    start = map.find {|l| x,y = from; l.is?(x,y) }
    stack = [[start,[]]]

    to_x, to_y = to

    loop do
      working_on, seen = stack.pop

      if working_on.is?(to_x,to_y)
        # p seen.length
        # p seen
        shortest = [shortest, seen.length].compact.min
        break if stack.length==0
        next
      end

      seen << working_on.coords

      north = map.find {|l| x,y = working_on.north_to; l.is?(x,y) }
      unless north.nil?
        stack.push [north, seen.clone] unless seen.include?(north.coords)
      end

      south = map.find {|l| x,y = working_on.south_to; l.is?(x,y) }
      unless south.nil?
        stack.push [south, seen.clone] unless seen.include?(south.coords)
      end

      east = map.find {|l| x,y = working_on.east_to; l.is?(x,y) }
      unless east.nil?
        stack.push [east, seen.clone] unless seen.include?(east.coords)
      end

      west = map.find {|l| x,y = working_on.west_to; l.is?(x,y) }
      unless west.nil?
        stack.push [west, seen.clone] unless seen.include?(west.coords)
      end

      # puts 'lets take this a step at a time'
      # p stack
      # q_to_quit

      break if stack.length == 0
    end
    shortest
  end

  def self.q_to_quit
    x=$stdin.getch
    exit if x == 'q'
  end
end