require_relative '../../helpers'
require 'io/console'
require 'set'

$debug = true

class Coord < Location
  attr_reader :elevation

  def initialize(x,y,e)
    @x = x
    @y = y
    @elevation = e.to_i
    @visited = false
  end
  def trailhead?
    return @elevation == 0
  end
  def visit
    @visited = true
  end
  def unvisit
    @visited = false
  end
  def to_s
    # trailhead? ? "#{@elevation}".green : "#{@elevation}".red
    return '.' if @elevation == -1

    @visited ? "#{@elevation}".green : "."
  end
  def inspect
    "[#{@x},#{@y}]"
  end

  def next_step
    around = $map.select do |c|
      (c.x == @x-1 and @x-1 >= 0 and c.y == @y) or
        (c.x == @x and (c.y == @y-1 or c.y == @y+1)) or
        (c.x == @x+1 and @x+1 < $max_y and c.y == @y)
    end
    around.select{|c| c.elevation == @elevation+1}
  end
  def next_step_oops
    around = $map.select do |c|
      (c.x == @x-1 and c.y > @y-1 and c.y < @y+1 and @x-1 >= 0 and @y-1 >= 0 and @y+1 < $max_y) or
        (c.x == @x and (c.y == @y-1 or c.y == @y+1) and @y-1 >= 0 and @y+1 < $max_y) or
       (c.x == @x+1 and c.y >= @y-1 and c.y <= @y+1 and @x+1 < $max_y and @y-1 >= 0 and @y+1 < $max_y)
    end
    around.select{|c| c.elevation == @elevation+1}
  end
end

class AOC
  def self.print_map
    puts
    for x in 0..$max_x do
      for y in 0..$max_y do
        print $map.find{|l| l.x==x and l.y==y}
      end
      puts
    end
  end

  def self.silver(lines)
    $map = []
    $max_x = lines.length
    $max_y = lines.first.split('').length
    lines.each_with_index do |line, x|
      line.split('').each_with_index do |l, y|
        if l == '.'
          $map << Coord.new(x,y,'-1')
        else
          $map << Coord.new(x,y,l)
        end
      end
    end
    AOC.print_map

    trailheads = $map.select{|l| l.trailhead?}
    # trailheads = [trailheads.first]

    $sum = []
    $reached = Set.new

    trailheads.each do |t|
      q = [t]

      loop do 
        break if q.empty?
        work = q.shift
        work.visit
        debug "working from #{work.inspect}"
        n = work.next_step
        debug "  next steps are #{n}"
        done = n.filter{|c| c.elevation == 9}
        debug "    done are #{done}"
        done.each {|d| d.visit}
        $reached.merge(done)
        q.concat n.reject{|c| c.elevation==9 or q.include? c} unless n.nil?
      end
      AOC.print_map
      debug $reached.size
      debug $reached
      $sum << $reached.size
      $reached = Set.new
      $map.each(&:unvisit)
    end

    $sum.sum
  end

  def self.gold(lines)
    $map = []
    $max_x = lines.length
    $max_y = lines.first.split('').length
    lines.each_with_index do |line, x|
      line.split('').each_with_index do |l, y|
        if l == '.'
          $map << Coord.new(x,y,'-1')
        else
          $map << Coord.new(x,y,l)
        end
      end
    end
    AOC.print_map if $debug

    trailheads = $map.select{|l| l.trailhead?}
    # trailheads = [trailheads.first]

    $sum = []
    $reached = []

    trailheads.each do |t|
      q = [t]

      loop do 
        break if q.empty?
        work = q.shift
        work.visit
        debug "working from #{work.inspect}"
        n = work.next_step
        debug "  next steps are #{n}"
        done = n.filter{|c| c.elevation == 9}
        debug "    done are #{done}"
        done.each {|d| d.visit}
        $reached.concat(done) unless done.empty?
        q.concat n.reject{|c| c.elevation==9} unless n.nil?
      end
      AOC.print_map if $debug
      debug "Reached size is #{$reached.size}"
      debug "Reached is :"
      debugp $reached
      $sum << $reached.size
      $reached = []
      $map.each(&:unvisit)
    end

    $sum.sum
  end
end
