require_relative '../../helpers'
require 'io/console'
require 'set'

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
  def self.parse(lines)
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

  def self.gold_map(lines, factor)
    row_expand = []
    col_expand = []
    lines.each_with_index do |line, index|
      row_expand << index if line.chars.all? { |c| c == '.' }
    end
    chars = lines.map{|l| l.chars}
    chars = chars.transpose
    chars.each_with_index do |line, index|
      col_expand << index if line.all? { |c| c == '.' }
    end

    p row_expand
    p col_expand

    count=1
    map = []
    lines.each_with_index do |row, row_index|
      row.chars.each_with_index do |col, col_index|
        next if col == '.'
        # we have a galaxy
        # we need to calc the offset.
        extra_rows = row_expand.select {|r| r < row_index}.count
        extra_cols = col_expand.select {|c| c < col_index}.count
        map << Location.new(row_index+(factor*extra_rows), col_index+(factor*extra_cols), count.to_s)
        count +=1
      end
    end
    map
  end

  def self.path_set(map)
    galaxies = map.filter {|l| l.is_galaxy? }
    count = galaxies.size
    paths = []
    (1..count).each do |from|
      (from+1..count).each do |to|
        paths << [from, to]
      end
    end

    paths
  end

  def self.path_between(map, from, to)
    start = map.find {|l| x,y = from; l.is?(x,y) }

    to_x, to_y = to
    from_x, from_y = from

    # determine if it is a straight line
    # because the shortest distance between two points is always a straight
    # line
    if to_x == from_x or to_y == from_y
      return to_y - from_y if to_x == from_x
      return to_x - from_x if to_y == from_y
    end

    return to_x-from_x + (to_y-from_y).abs
  end

  def self.q_to_quit
    x=$stdin.getch
    exit if x == 'q'
  end
end
