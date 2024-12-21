require_relative '../../helpers'
require 'io/console'
require 'set'

class Wall < Location
  def to_s
    "#"
  end
end

class Path < Location
  def initialize(x, y, s = false, e = false)
    @x = x
    @y = y
    @start = s
    @end = e
  end

  def is_start?
    @start
  end

  def is_end?
    @end
  end

  def to_s
    return'S' if is_start?

    return 'E' if is_end?

    '•'
  end
end

class Reindeer < Location
  BEARINGS = ['N','E','S','W']
  def initialize(x, y)
    @x = x
    @y = y
    @score = 0 
    @bearing = 1
  end

  def turn_clockwise
    @score += 1000
    @bearing = (@bearing + 1) % 4
  end

  def turn_counterclockwise
    @score += 1000
    @bearing = (@bearing + 1) % 4
  end

  def move
    case @bearing
    when 0
      return false unless $grid.find{|l| l.x == @x-1 and l.y == @y}.is_a? Path
      @x -= 1
    when 1
      return false unless $grid.find{|l| l.x == @x and l.y == @y+1}.is_a? Path
      @y += 1
    when 2
      return false unless $grid.find{|l| l.x == @x+1 and l.y == @y}.is_a? Path
      @x += 1
    when 3
      return false unless $grid.find{|l| l.x == @x and l.y == @y-1}.is_a? Path
      @y -= 1
    end

    @score += 1
    true
  end

  def bearing
    BEARINGS[@bearing]
  end
end

class AOC
  def self.print_grid
    for x in 0..$mx do
      for y in 0..$my do
        if $deer.x==x and $deer.y==y
          print "\u2588".green
        else
          loc = $grid.find{|l| l.x==x and l.y==y}
          print loc
        end
      end
      puts
    end
  end

  def self.silver(lines)
    $grid = []
    $mx, $my = lines_by_index(lines) do |x, y, v|
      case v
      when '#'
        $grid << Wall.new(x, y)
      when '.'
        $grid << Path.new(x, y)
      when 'S'
        $grid << Path.new(x, y, true)
        $deer = Reindeer.new(x,y)
      when 'E'
        $grid << Path.new(x, y, false, true)
      end
    end

    AOC.print_grid

    AOC.do_silver
  end

  def self.do_silver

  end

  def self.gold(lines)
  end
end
