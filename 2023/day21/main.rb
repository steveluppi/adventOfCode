require_relative '../../helpers'
require 'progress_bar'
require 'io/console'
require 'set'

class Location
  attr_reader :row, :col, :label

  def initialize(label, row, col)
    @label = label
    @row = row
    @col = col
  end

  def inspect
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

  def is_rock?
    return @label == '#'
  end

  def coords
    [@row, @col]
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
end

class AOC
  def self.print_grid(g, r, c)
  r.times do |rx|
      c.times do |cx|
        loc = g[[rx,cx]]
        # print loc.label
        case loc.label
        when 'S'
          print 'S'.green
        when '.'
          print '•'
        when '#'
          print '#'.red
        end
      end
      puts
    end
  end

  def self.print_grid_steps(g, s, r, c)
  r.times do |rx|
      c.times do |cx|
        loc = g[[rx,cx]]
        # print loc.label
        if s.include? [rx,cx]
          print 'O'.green
        else
          case loc.label
          when 'S'
            print 'S'
          when '.'
            print '•'
          when '#'
            print '#'.red
          end
        end
      end
      puts
    end
  end

  def self.in_grid?(coords,rx,cx)
    r,c = coords.map(&:to_i)
    r >= 0 and r < rx and c >= 0 and c < cx
  end

  def self.silver(lines)
    grid = {}
    row_count = lines.length
    col_count = lines[0].length
    lines.each_with_index do |line, rx|
      line.chars.each_with_index do |c, cx|
        grid[[rx,cx]] = Location.new(c, rx, cx)
      end
    end

    puts
    print_grid(grid, row_count, col_count) 
    puts

    steps = Set.new
    steps << grid.values.find{|l| l.is_start? }.coords
    64.times do
      new_steps = Set.new
      steps.each do |coords|
        r,c = coords
        loc = grid[coords]
        new_steps << loc.north_to if in_grid?(loc.north_to, row_count, col_count) and !grid[loc.north_to].is_rock?
        new_steps << loc.south_to if in_grid?(loc.south_to, row_count, col_count) and !grid[loc.south_to].is_rock?
        new_steps << loc.west_to if in_grid?(loc.west_to, row_count, col_count) and !grid[loc.west_to].is_rock?
        new_steps << loc.east_to if in_grid?(loc.east_to, row_count, col_count) and !grid[loc.east_to].is_rock?
      end
      steps = new_steps
      # print_grid_steps(grid,steps,row_count,col_count)
      # puts
    end
    print_grid_steps(grid,steps,row_count,col_count)
    steps.size
  end

  def self.north_to(x)
    r,c = x
    [r-1, c]
  end

  def self.south_to(x)
    r,c = x
    [r+1, c]
  end

  def self.west_to(x)
    r,c = x
    [r, c-1]
  end

  def self.east_to(x)
    r,c = x
    [r, c+1]
  end

  def self.in_grid(coords)
    x,y = coords
    [x % $rx, y % $cx]
  end
  def self.gold(lines)
    grid = {}
    row_count = lines.length
    $rx = row_count
    col_count = lines[0].length
    $cx = row_count
    lines.each_with_index do |line, rx|
      line.chars.each_with_index do |c, cx|
        grid[[rx,cx]] = Location.new(c, rx, cx)
      end
    end

    puts
    print_grid(grid, row_count, col_count) 
    puts

    steps = Set.new
    steps << grid.values.find{|l| l.is_start? }.coords
    iterations = 200
    # iterations = 26501365
    pb = ProgressBar.new iterations
    iterations.times do
      new_steps = Set.new
      steps.each do |coords|
        # puts "Taking step from #{coords}"
        r,c = coords

        r %= row_count
        c %= col_count
        # puts "which map to #{r}, #{c}"

        n = north_to coords
        s = south_to coords
        w = west_to coords
        e = east_to coords

        # puts "which are"
        # p n,s,w,e

        new_steps << n unless grid[in_grid n].is_rock?
        new_steps << s unless grid[in_grid s].is_rock?
        new_steps << w unless grid[in_grid w].is_rock?
        new_steps << e unless grid[in_grid e].is_rock?
        # p new_steps
      end
      steps = new_steps
      print_grid_steps(grid,steps,row_count,col_count)
      puts
      puts steps.select {|c| x,y=c; x>0 and x<row_count and y>0 and y<col_count}.size
      pb.increment!
    end
    print_grid_steps(grid,steps,row_count,col_count)
    steps.size
  end
end
