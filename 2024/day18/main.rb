require_relative '../../helpers'
require 'io/console'
require 'set'

class GridWalker < GridLocation
  attr_accessor :score
  attr_reader :bearing, :path

  DIRECTIONS = {
    'n' => { r: -1, c: 0, turns: ['n', 's', 'e', 'w'] },
    'e' => { r: 0, c: 1, turns: ['n', 's', 'e', 'w'] },
    's' => { r: 1, c: 0, turns: ['n', 's', 'e', 'w'] },
    'w' => { r: 0, c: -1, turns: ['n', 's', 'e', 'w'] },
  }

  def initialize(r, c)
    @r = r
    @c = c
    @score = 0 
    @bearing = 'e'
    @path = Set.new
  end

  def forward direction
    @score += 1
    @path << "#{@r},#{@c}"
    @bearing = direction
    @r += DIRECTIONS[direction][:r]
    @c += DIRECTIONS[direction][:c]

    self
  end

  def direction(direction=@bearing)
    DIRECTIONS[direction]
  end

  def is_end?
    @r == $end_coord[0] and @c == $end_coord[1]
  end

  def inspect
    "GridWalker[#{@r}, #{@c}]: #{@score}"
  end

  def print_path
    for r in 0..$mr do
      for c in 0..$mc do
        visit = @path.include?("#{r},#{c}")
        print visit ? "O".green : $grid[r][c]
      end
      puts
    end
  end
end

$debug = false
class AOC
  def self.in_bounds? coord
    coord.first >= 0 and coord.first <= $mr and coord.last >= 0 and coord.last <= $mc
  end

  def self.print_grid
    for r in 0..$mr do
      for c in 0..$mc do
        print $grid[r][c]
      end
      puts
    end
  end

  def self.silver(lines)
    $mr = 70
    $mc = 70
    $end_coord = [$mr,$mc]

    bytes = lines.shift(1024)
    
    # make the map
    $grid = []
    for r in 0..$mr do
      row = []
      for c in 0..$mc do
        k = bytes.find{|l| l=="#{c},#{r}"}
        row << (k.nil? ? '•' : '#')
      end
      $grid << row
    end

    # AOC.print_grid

    AOC.do_silver
  end
  def self.do_silver
    q = [GridWalker.new(0,0)]

    $seen = []
    loop do
      q.sort_by!(&:score)
      debug "queue length is #{q.length}"
      c = q.shift
      # AOC.print_grid
      # puts
      # c.print_path
      debug "working on "
      debugp c
      next if $seen.include?("#{c.r},#{c.c}")
      $seen << "#{c.r},#{c.c}"

      return c.score if c.is_end?

      c.direction[:turns].each do |new_heading|
        debug "Looking for new heading going #{new_heading}"
        nc = [c.r + c.direction(new_heading)[:r], c.c + c.direction(new_heading)[:c]]
        clone = Marshal.load(Marshal.dump(c))
        q << clone.forward(new_heading) if AOC.in_bounds?(nc) and !$seen.include?("#{nc.first},#{nc.last}") and $grid[nc.first][nc.last] != '#'
      end
      debug "seen is #{$seen}"
      debugp q

      break if q.empty?
    end
  end

  def self.real_grid
    $mr = 70
    $mc = 70
    $byte_count = 1024
  end

  def self.ex_grid
    $mr = 6
    $mc = 6
    $byte_count = 12
  end

  def self.gold(lines)
    AOC.real_grid
    $end_coord = [$mr,$mc]

    bytes = lines.slice(0, $byte_count)
    
    # make the map
    $grid = []
    for r in 0..$mr do
      row = []
      for c in 0..$mc do
        k = bytes.find{|l| l=="#{c},#{r}"}
        row << (k.nil? ? '•' : '#')
      end
      $grid << row
    end

    AOC.print_grid
    walker = AOC.gold_path
    puts
    walker.print_path
    byte_at = $byte_count
    loop do
      # get the next byte to drop
      byte = lines[byte_at]
      bc = byte.split(',').map(&:to_i)
      puts "add #{byte}, #{bc}"
      $grid[bc.last][bc.first] = '#'

      # AOC.print_grid

      walker = AOC.gold_path if walker.path.include?("#{bc.last},#{bc.first}")

      break if walker.nil?
      # puts
      # walker.print_path
      byte_at+=1
    end
    puts lines[byte_at]
    lines[byte_at]
  end

  def self.gold_path
    q = [GridWalker.new(0,0)]

    $seen = []
    loop do
      q.sort_by!(&:score)
      c = q.shift

      next if $seen.include?("#{c.r},#{c.c}")
      $seen << "#{c.r},#{c.c}"

      return c if c.is_end?

      c.direction[:turns].each do |new_heading|
        nc = [c.r + c.direction(new_heading)[:r], c.c + c.direction(new_heading)[:c]]
        clone = Marshal.load(Marshal.dump(c))
        q << clone.forward(new_heading) if AOC.in_bounds?(nc) and !$seen.include?("#{nc.first},#{nc.last}") and $grid[nc.first][nc.last] != '#'
      end

      break if q.empty?
    end

    nil
  end
end
