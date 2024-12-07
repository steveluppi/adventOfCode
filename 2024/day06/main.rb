require_relative '../../helpers'
require 'io/console'
require 'progress_bar'
require 'set'

class Location
  attr_reader :x
  attr_reader :y

  def initialize(l, x, y)
    @origin = l
    @letter = l
    @x = x
    @y = y
    @visits = []
  end

  def is_obstacle?
    @letter == '#'
  end

  def make_obstacle
    @letter = '#'
  end

  def visit
    @visited = true
    @visits << $guard.h
  end

  def visited?
    @visited
  end

  def visited_in_pattern?
    @visits.include? $guard.h
  end

  def back_to_original
    @visited=false
    @visits = []
    @letter = @origin
  end

  def inspect
    @visited ? @letter.red : @letter
  end

  def to_s
    @visited ? @letter.red : @letter
  end
end

class Guard
  attr_reader :x
  attr_reader :y
  attr_reader :h

  def initialize(h, x, y)
    @x = x
    @y = y
    @h = h
    @origin = [x,y,h]
  end

  def reset
    @x = @origin[0]
    @y = @origin[1]
    @h = @origin[2]
  end

  def turn
    case @h
    when '^'
      @h = '>'
    when '>'
      @h = 'v'
    when '<'
      @h = '^'
    when 'v'
      @h = '<'
    end
  end

  def move_thru_grid
    case @h
    when '^'
      new_pos = $grid.find{|g| g.x == @x-1 and g.y == @y}
      if new_pos.nil?
        @x = -1
        @y = -1
      elsif new_pos.is_obstacle?
        self.turn
      else
        @x -= 1
      end
    when '>'
      new_pos = $grid.find{|g| g.x == @x and g.y == @y+1}
      if new_pos.nil?
        @x = -1
        @y = -1
      elsif new_pos.is_obstacle?
        self.turn
      else
        @y += 1
      end
    when '<'
      new_pos = $grid.find{|g| g.x == @x and g.y == @y-1}
      if new_pos.nil?
        @x = -1
        @y = -1
      elsif new_pos.is_obstacle?
        self.turn
      else
        @y -= 1
      end
    when 'v'
      new_pos = $grid.find{|g| g.x == @x+1 and g.y == @y}
      if new_pos.nil?
        @x = -1
        @y = -1
      elsif new_pos.is_obstacle?
        self.turn
      else
        @x += 1
      end
    end
  end

  def inspect
    @h.green
  end

  def to_s
    @h.green
  end
end

class AOC
  def self.print_grid
    for x in 0..$max_x
      for y in 0..$max_y
        loc = $grid.find{|l| l.x == x and l.y == y}
        print loc unless $guard.x == x and $guard.y == y
        print $guard.h if $guard.x == x and $guard.y == y
      end
      puts
    end
  end

  def self.silver(lines)
    $grid = []
    $guard = nil

    $max_x = lines.length
    $max_y = lines[0].length

    lines.each_with_index do |line, x_idx|
      line.split('').each_with_index do |l, y_idx|
        if l.match? /\^|\>|\<|\v]/
          $guard = Guard.new(l, x_idx, y_idx)
          $grid << Location.new('.', x_idx, y_idx)
        else
          $grid << Location.new(l, x_idx, y_idx)
        end
      end
    end

    loop do
      pos = $grid.find{|l| l.x==$guard.x and l.y==$guard.y}
      pos.visit

      $guard.move_thru_grid

      break if $guard.x < 0 or $guard.x > $max_x or $guard.y < 0 or $guard.y > $max_y
    end

    $grid.select{|g| g.visited?}.size
  end

  def self.gold(lines)
    $total = 0
    # now we have a grid, that has all the visits
    AOC.silver lines

    options = $grid.filter(&:visited?).map{|g| [g.x, g.y]}

    pb = ProgressBar.new options.count
    options.each do |opt|
      $grid.each {|g| g.back_to_original}
      $guard.reset

      update = $grid.find{|l| opt[0]==l.x and opt[1]==l.y}
      # puts "Attempting to update #{update.x},#{update.y}"
      update.make_obstacle


      loop do
        pos = $grid.find{|l| l.x==$guard.x and l.y==$guard.y}
        if pos.visited_in_pattern?
          # puts "We've been here in this way before"
          $total += 1
          break;
        end
        pos.visit

        $guard.move_thru_grid

        break if $guard.x < 0 or $guard.x > $max_x or $guard.y < 0 or $guard.y > $max_y
      end
      pb.increment!
    end

    $total
  end
end
