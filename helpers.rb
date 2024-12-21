require 'colorize'

def read_file_and_chomp(file_path)
  File.readlines(file_path).map(&:chomp)
end

def read_file_to_array(file_path)
  File.readlines(file_path).map(&:chomp).first.split(',').map(&:to_i)
end

def read_file_to_array_of_single_char(file_path)
  File.readlines(file_path).map(&:chomp).map { |x| x.split('') }
end

def array_to_i(input)
  input.map(&:to_i)
end

# class String
#   def red = "\e[31m#{self}\e[0m"
#   def green = "\e[32m#{self}\e[0m"
#   def blue = self.colorize(:blue)
# end

def i_log(message, indent = 0)
  indent.times { |_x| print ' ' }
  puts message
end

def debugp(msg)
  p msg if $debug
end

def debug(msg)
  puts msg if $debug
end

def continue
  print "...Press any key to continue\r"
  gets
end

class GridLocation
  attr_reader :r
  attr_reader :c
  def initialize(r,c)
    @r = r
    @c = c
  end

  def to_s
    "#{@r},#{@c}"
  end
  def inspect
    "GridLocation[#{@r}, #{@c}]"
  end
end

class Location
  attr_reader :x
  attr_reader :y
  def initialize(x,y)
    @x = x
    @y = y
  end

  def to_s
    "#{@x},#{@y}"
  end
  def inspect
    "Location[#{@x}, #{@y}]"
  end
end

class Pathfinder < GridLocation
  attr_accessor :score
  attr_reader :bearing, :path

  DIRECTIONS = {
    'n' => { r: -1, c: 0, turns: ['n', 's', 'e', 'w'] },
    'e' => { r: 0, c: 1, turns: ['n', 's', 'e', 'w'] },
    's' => { r: 1, c: 0, turns: ['n', 's', 'e', 'w'] },
    'w' => { r: 0, c: -1, turns: ['n', 's', 'e', 'w'] },
  }

  def initialize(r:, c:, bearing: 'e')
    @r = r
    @c = c
    @score = 0 
    @bearing = bearing
    @path = []
  end

  def forward direction
    @score += 1
    @path << "#{@r},#{@c}"
    @bearing = direction
    @r += DIRECTIONS[direction][:r]
    @c += DIRECTIONS[direction][:c]

    self
  end

  def location
    "#{@r},#{@c},#{@bearing}"
  end

  def direction(direction=@bearing)
    DIRECTIONS[direction]
  end

  def to(direction)
    [@r + DIRECTIONS[direction][:r], @c + DIRECTIONS[direction][:c]]
  end

  def is_end?
    @r == $end[0] and @c == $end[1]
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

def lines_by_index(lines, &block)
  lines.each_with_index do |row, r_idx|
    row.split('').each_with_index do |col, c_idx|
      yield(r_idx, c_idx, col)
    end
  end
  [lines.length-1, lines.first.split('').length-1]
end

def print_grid(doit = $debug)
  return unless doit
  for r in 0..$mr do
    for c in 0..$mc do
      print $grid[r][c]
    end
    puts
  end
end

