# Advent of Code - Day x
require_relative '../../helpers'
require 'set'

$grid = []

def print_grid
  $max_row.times do |row|
    3.times do |mini_row|
      $max_col.times do |col|
        loc = $grid.find { |l| l.is?(row,col) }
        print "| #{loc.north? ? '^'.red : ' '} |" if mini_row == 0
        print "|#{loc.west? ? '<'.red : ' '}#{loc.label}#{loc.east? ? '>'.red : ' '}|" if mini_row == 1
        print "| #{loc.south? ? 'v'.red : ' '} |" if mini_row == 2
      end
    puts
    end
  puts
  end
end

class Location
  attr_reader :row
  attr_reader :col
  attr_reader :label
  attr_accessor  :seen
  attr_accessor :parent

  def initialize(label, row, col, parent=nil)
    @label = label
    @row = row
    @col = col
    @seen = false
    @parent = parent
  end

  def inspect
    # @label == '.' ? @label : @label.red
    "#{@label} at #{@row}, #{@col}"
  end

  def to_s
    "#{@label} at #{@row}, #{@col}"
  end

  def is_start?
    @label == 'S'
  end

  def is?(r, c)
    @row==r && @col==c
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
    lines[@label] || @label.red
  end
  def coords
    [@row, @col]
  end

  def vertical?
    (north? and south?)
  end
  
  def horizontal?
    (west? and east?)
  end

  def corner?
    @label =~ /[S7JFL]/
  end

  def move_north?
    return false unless north?
    # puts "can #{self} move north?"
    x,y = north_to
    up = $grid.find {|i| i.is?(x,y)}
    return false if up.nil?
    # puts "up is #{up} and #{up.south?}"
    return true if up.south?
    false
  end
  
  def move_south?
    return false unless south?
    x,y = south_to
    down = $grid.find { |i| i.is?(x,y) }
    return false if down.nil?
    return true if down.north?
    false
  end

  def move_west?
    return false unless west?
    x,y = west_to
    left = $grid.find { |i| i.is?(x,y) }
    return false if left.nil?
    return true if left.east?
    false
  end

  def move_east?
    return false unless east?
    x,y = east_to
    right = $grid.find { |i| i.is?(x,y) }
    return false if right.nil?
    return true if right.west?
    false
  end

  def north?
    return false unless 'S|LJ'.chars.include? @label
    true
  end
  def north_to
    [@row-1, @col]
  end

  def south?
    return false unless 'S|7F'.chars.include? @label
    true
  end
  def south_to
    [@row+1, @col]
  end

  def west?
    return false unless 'S-7J'.chars.include? @label
    true
  end
  def west_to
    [@row, @col-1]
  end

  def east?
    return false unless 'S-LF'.chars.include? @label
    true
  end
  def east_to
    [@row, @col+1]
  end
end

def silver(input)
  $max_row = input.length
  $max_col = input[0].length
  input.each_with_index do |i, r_idx|
    i.chars.each_with_index { |c, c_idx| $grid << Location.new(c, r_idx, c_idx) }
  end
  
  start = $grid.find { |l| l.is_start? }
  visited = Set[start.coords]
  current = Set.new
  p start
  current << start.north_to if start.move_north?
  current << start.south_to if start.move_south?
  current << start.east_to if start.move_east?
  current << start.west_to if start.move_west?
  p visited
  p current

  count = 1
  while current.length > 1
    count += 1
    # visited.add current
    current.each {|c| visited << c }
    # visited.flatten!
    # puts "visited is now #{visited}"
    # puts "current is #{current}"
    new_current = Set.new
    current.each do |coord|
      x,y = coord
      l = $grid.find { |a| a.is?(x,y) }

      new_current << l.north_to if l.move_north? and not visited.include? l.north_to
      new_current << l.south_to if l.move_south? and not visited.include? l.south_to
      new_current << l.east_to if l.move_east? and not visited.include? l.east_to
      new_current << l.west_to if l.move_west? and not visited.include? l.west_to
    end
    current = new_current
    # puts "and we end with the new current being #{current}"
  end

  count
end

def gold(input)
  $grid = []
  $big_grid = []
  $max_row = input.length
  $max_col = input[0].length
  input.each_with_index do |i, r_idx|
    i.chars.each_with_index do |c, c_idx| 
      main_location = Location.new(c, r_idx, c_idx)
      $grid << main_location
      $big_grid << Location.new('.', r_idx*3+0, c_idx*3+0, main_location)
      $big_grid << Location.new(main_location.north? ? '|' : '.', r_idx*3+0, c_idx*3+1, main_location)
      $big_grid << Location.new('.', r_idx*3+0, c_idx*3+2, main_location)
      $big_grid << Location.new(main_location.west? ? '-' : '.', r_idx*3+1, c_idx*3+0, main_location)
      $big_grid << Location.new(c, r_idx*3+1, c_idx*3+1, main_location)
      $big_grid << Location.new(main_location.east? ? '-' : '.', r_idx*3+1, c_idx*3+2, main_location)
      $big_grid << Location.new('.', r_idx*3+2, c_idx*3+0, main_location)
      $big_grid << Location.new(main_location.south? ? '|' : '.', r_idx*3+2, c_idx*3+1, main_location)
      $big_grid << Location.new('.', r_idx*3+2, c_idx*3+2, main_location)
    end
  end
  
  start = $grid.find { |l| l.is_start? }
  visited = Set[start.coords]
  current = Set.new
  current << start.north_to if start.move_north? and current.size == 0
  current << start.south_to if start.move_south? and current.size == 0
  current << start.east_to if start.move_east? and current.size == 0
  current << start.west_to if start.move_west? and current.size == 0

  # while current.length > 1
  loop do
    # visited.add current
    current.each {|c| visited << c }
    # visited.flatte!
    # puts "visited is now #{visited}"
    # puts "current is #{current}"
    new_current = Set.new
    current.each do |coord|
      x,y = coord
      l = $grid.find { |a| a.is?(x,y) }

      new_current << l.north_to if l.move_north? and not visited.include? l.north_to
      new_current << l.south_to if l.move_south? and not visited.include? l.south_to
      new_current << l.east_to if l.move_east? and not visited.include? l.east_to
      new_current << l.west_to if l.move_west? and not visited.include? l.west_to
    end
    current = new_current
    # puts "and we end with the new current being #{current}"
    break if current.length == 0
  end

  # print_grid

  # input.each_with_index do |row, r_idx|
  #   row.chars.each_with_index do |col, c_idx|
  #     pos = $grid.find {|g| g.is?(r_idx, c_idx) }
  #     been_here = visited.include?([r_idx, c_idx])
  #     # print been_here ? 'v' : '.'
  #     # print been_here ? (pos.horizontal? ? '-' : (pos.vertical? ? '|' : '.')) : '.'
  #     # print been_here ? (pos.corner? ? 'X' : (pos.horizontal? ? '-' : (pos.vertical? ? '|' : '.'))) : '.'
  #     g = pos.graphic
  #     print been_here ? g.green : g
  #   end
  #   puts
  # end

  p input.length*3
  p input[0].chars.length*3
  
  # (input.length * 3).times do |r_idx|
  #   (input[0].length * 3).times do |c_idx|
  #     pos = $big_grid.find { |g| g.is?(r_idx, c_idx) }
  #     been_here = visited.include?(pos.parent.coords)
  #     g = pos.graphic
  #     print been_here ? g.green : g
  #   end
  #   puts
  # end

  # The loop goes here.
  stack = []
  start = $big_grid.find {|l| l.is?(0,0) }

  stack.push start

  loop do
    working_on = stack.pop
    puts "working on #{working_on}"
    working_on.seen = true
    working_on.parent.seen = true

    north = $big_grid.find {|l| x,y = working_on.north_to; l.is?(x,y) }
    unless north.nil?
      stack.push north if (north.label == '.' or !visited.include?(north.parent.coords)) and north.seen == false
    end

    south = $big_grid.find {|l| x,y = working_on.south_to; l.is?(x,y) }
    unless south.nil?
      stack.push south if (south.label == '.' or !visited.include?(south.parent.coords)) and south.seen == false
    end

    east = $big_grid.find {|l| x,y = working_on.east_to; l.is?(x,y) }
    unless east.nil?
      stack.push east if (east.label == '.' or !visited.include?(east.parent.coords)) and east.seen == false
    end

    west = $big_grid.find {|l| x,y = working_on.west_to; l.is?(x,y) }
    unless west.nil?
      stack.push west if (west.label == '.' or !visited.include?(west.parent.coords)) and west.seen == false
    end

    break if stack.length == 0
  end

  # (input.length * 3).times do |r_idx|
  #   (input[0].length * 3).times do |c_idx|
  #     pos = $big_grid.find { |g| g.is?(r_idx, c_idx) }
  #     been_here = visited.include?(pos.parent.coords)
  #     g = pos.graphic
  #     print pos.seen ? g.red : been_here ? g.green : g
  #   end
    # puts
  # end

  # seen = $grid.map { |l| l.seen ? 1 : 0 }.inject(:+)
  # puts "#{seen} is how many were seen"
  not_seen = $grid.map { |l| l.seen ? 0 : 1 }.inject(:+)
  puts "#{not_seen} is how many were not seen"
  # inside = not_seen - visited.size
  # puts "which makes #{inside} the number inside because we took away #{visited.size}"

  # input.each_with_index do |row, r_idx|
  #   row.chars.each_with_index do |col, c_idx|
  #     pos = $grid.find {|g| g.is?(r_idx, c_idx) }
  #     been_here = visited.include?([r_idx, c_idx])
  #     g = pos.graphic
  #     print pos.seen ? g.red : been_here ? g.green : g
  #   end
  #   puts
  # end

  not_seen
end

# Main execution
# @input = read_file_and_chomp(
#   case ARGV[0]
#   when 'silver'
#     'silver.txt'
#   when 'gold'
#     'gold.txt'
#   else
#     'example.txt'
#   end
# )

# puts "Silver: #{silver(@input)}"
# puts "Gold: #{gold(@input)}"
