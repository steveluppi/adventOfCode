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

  def initialize(label, row, col)
    @label = label
    @row = row
    @col = col
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
  $max_row = input.length
  $max_col = input[0].length
  input.each_with_index do |i, r_idx|
    i.chars.each_with_index { |c, c_idx| $grid << Location.new(c, r_idx, c_idx) }
  end
  
  start = $grid.find { |l| l.is_start? }
  visited = Set[start.coords]
  current = Set.new
  p start
  current << start.north_to if start.move_north? and current.size == 0
  current << start.south_to if start.move_south? and current.size == 0
  current << start.east_to if start.move_east? and current.size == 0
  current << start.west_to if start.move_west? and current.size == 0
  p visited
  p current

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

  print_grid

  inside = 0
  are_inside = false
  input.each_with_index do |row, r_idx|
    pipes = 2
    are_in_hor = false
    horiz_edge_pipe = false
    row.chars.each_with_index do |col, c_idx|
      pos = $grid.find {|g| g.is?(r_idx, c_idx) }
      # puts "We are at #{r_idx} and #{c_idx}"
      # puts " and its visit state is #{visited.include? [r_idx, c_idx]}"
      # if we hit a pipe, and we were not inside
      been_here = visited.include?([r_idx, c_idx])
      # print been_here ? 'v' : '.'
      # print been_here ? (pos.horizontal? ? '-' : (pos.vertical? ? '|' : '.')) : '.'
      # print been_here ? (pos.corner? ? 'X' : (pos.horizontal? ? '-' : (pos.vertical? ? '|' : '.'))) : '.'
      # next

      if pos.corner?
        # print "X"
        if are_in_hor
          # this is the end of a horizontal pipe
          are_in_hor = false
          n = $grid.find{|l| l.is?(r_idx, c_idx+1)}
          edge = n.vertical? and visited.include?(n.coords)
          counts = edge and horiz_edge_pipe
          print counts ? 'E' : 'e'
          pipes += 1 if counts 
          are_inside = !are_inside if counts
        else
          # print "B"
          # this is the beginning of a horizontal pipe
          are_in_hor = true
          prev = $grid.find{|l| l.is?(r_idx, c_idx-1)}
          horiz_edge_pipe = prev.vertical? and visited.include?(prev.coords)
          print horiz_edge_pipe ? 'B' : 'b'
          are_inside = !are_inside if horiz_edge_pipe
        end
      elsif pos.horizontal?
        if been_here
          print '-'
        else
          inside += 1 if are_inside
          print are_inside ? 'I' : 'O'
        end
      elsif pos.vertical?
        print "|"
        are_inside = !are_inside
        pipes += 1
      elsif !been_here
        # do nothing?
        inside += 1 if are_inside
        print are_inside ? '•'.red : '.'
      else 
        p pos
        throw "WHERE ARE WE"
      end
    end
    puts
    # are_inside = false # this should be removalbe
  end
  inside
end

# Main execution
@input = read_file_and_chomp(
  case ARGV[0]
  when 'silver'
    'silver.txt'
  when 'gold'
    'gold.txt'
  else
    'example.txt'
  end
)

puts "Silver: #{silver(@input)}"
puts "Gold: #{gold(@input)}"
