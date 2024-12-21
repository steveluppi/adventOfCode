require_relative '../../helpers'
require 'io/console'
require 'set'

class Wall < GridLocation
  def to_s
    "#"
  end
end

class Path < GridLocation
  def initialize(r, c, s = false, e = false)
    @r = r
    @c = c
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

class Reindeer < GridLocation
  attr_accessor :score
  attr_reader :bearing, :path

  DIRECTIONS = {
    'n': { r: -1, c: 0, turns: ['n', 's', 'e', 'w'] },
    'e': { r: 0, c: 1, turns: ['n', 's', 'e', 'w'] },
    's': { r: 1, c: 0, turns: ['n', 's', 'e', 'w'] },
    'w': { r: 0, c: -1, turns: ['n', 's', 'e', 'w'] },
  }

  def initialize(r, c)
    @r = r
    @c = c
    @score = 0 
    @bearing = 'e'
    @path = Set.new
  end

  def forward direction
    @score += @bearing == direction ? 1 : 1001
    @path << "#{@r},#{@c}"
    @bearing = direction
    @r += DIRECTIONS[direction.to_sym][:r]
    @c += DIRECTIONS[direction.to_sym][:c]

    self
  end

  def direction(direction=@bearing)
    DIRECTIONS[direction.to_sym]
  end

  def is_end?
    @r == $end_coord[0] and @c == $end_coord[1]
  end

  def add_to_path l
    @path << l
  end

  def inspect
    "Deer[#{@r}, #{@c}]: #{@score}"
  end
end

class AOC
  def self.print_grid
    for r in 0..$mr do
      for c in 0..$mc do
        print $seats.include?("#{r},#{c}") ? "O".red : $grid[r][c]
      end
      puts
    end
  end

  def self.silver(lines)
    $grid = lines
    $mr = lines.length-1
    $mc = lines.first.length-1
    $end_coord = [1, $mc-1]

    $deer = Reindeer.new($mr-1,1)

    AOC.print_grid

    low_score = AOC.do_silver
    puts "Low score was #{low_score}"

    low_score
  end

  def self.do_silver
    q = [$deer]

    $seen = []
    loop do
      q.sort_by!(&:score)

      deer = q.shift
      $seen << "#{deer.r},#{deer.c}"

      return deer.score if deer.is_end?

      coord = [deer.r+deer.direction[:r], deer.c+deer.direction[:c]]
      q << deer.clone.forward(deer.bearing) unless $seen.include?("#{coord.first},#{coord.last}") or $grid[coord.first][coord.last] == '#'

      deer.direction[:turns].each do |new_heading|
        coord = [deer.r+deer.direction(new_heading)[:r], deer.c+deer.direction(new_heading)[:c]]
        q << deer.clone.forward(new_heading) unless $seen.include?("#{coord.first},#{coord.last}") or $grid[coord.first][coord.last] == '#'
      end

      break if q.empty?
    end
  end

  def self.do_gold
    q = [$deer]

    $seen = {}
    $seats = Set.new
    $best = nil

    loop do
      break if q.empty?
      print "\r Queue Length #{q.length}      "
      q.sort_by!(&:score)

      deer = q.shift
      if !$best.nil? and deer.score > $best
        puts "This is not better than our best... we skip"
        next
      end

      if !$seen["#{deer.r},#{deer.c},#{deer.bearing}"].nil? and $seen["#{deer.r},#{deer.c},#{deer.bearing}"] < deer.score
        next
      else
        $seen["#{deer.r},#{deer.c},#{deer.bearing}"] = deer.score
      end

      if deer.is_end?
        puts "Path for #{deer.inspect} made it"
        deer.add_to_path("#{deer.r},#{deer.c}")
        $best = deer.score
        $seats = $seats.merge(deer.path)
        next
      end

      coord = [deer.r+deer.direction[:r], deer.c+deer.direction[:c]]
      unless ($seen["#{coord.first},#{coord.last},#{deer.bearing}"] and $seen["#{coord.first},#{coord.last},#{deer.bearing}"] > deer.score) or $grid[coord.first][coord.last] == '#'
        debug "move forward"
        cloned = Marshal.load(Marshal.dump(deer))
        q << cloned.forward(deer.bearing)
      end

      deer.direction[:turns].each do |new_heading|
        coord = [deer.r+deer.direction(new_heading)[:r], deer.c+deer.direction(new_heading)[:c]]
        unless($seen["#{coord.first},#{coord.last},#{deer.bearing}"] and $seen["#{coord.first},#{coord.last},#{deer.bearing}"] > deer.score) or $grid[coord.first][coord.last] == '#'
          debug "moving #{new_heading}"
          cloned = Marshal.load(Marshal.dump(deer))
          q << cloned.forward(new_heading)
        end
      end
    end
    puts $seen
  end

  def self.gold(lines)
    $grid = lines
    $mr = lines.length-1
    $mc = lines.first.length-1
    $end_coord = [1, $mc-1]

    $deer = Reindeer.new($mr-1,1)


    AOC.do_gold
    AOC.print_grid

    p $seats.size

    $seats.size
  end
end
