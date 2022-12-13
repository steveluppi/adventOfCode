# Advent of Code - Day x
require_relative "../helpers"
require "set"

class Point 
  attr_reader :x, :y, :height
  attr_reader :up, :down, :left, :right
  attr_accessor :is_start, :is_end, :visited, :distance

  def initialize(x,y,h,d)
    @x=x
    @y=y
    @height=h.to_i(36)
    @visited = false
    @distance = d
    @up = make_key(x-1,y)
    @down = make_key(x+1,y)
    @left = make_key(x,y-1)
    @right = make_key(x,y+1)
  end
  def key
    "#{@x},#{@y}"
  end
  def to_s
    "[#{@x},#{@y}] => h:#{@height} / d:#{@distance} / v:#{@visited}"
  end
end

def make_key(x,y)
  "#{x},#{y}"
end

def print_map(points)
  puts "Current Map:"
  puts
  for r in (0..points.map{|x,p| p.x}.max)
    for c in (0..points.map{|y,p| p.y}.max)
      point = points[make_key(r,c)]
      if point.is_start or point.is_end
        print point.is_start ? "S".red : "E".red
      else
        print point.height.to_s(36)
      end
    end
    puts
  end
  puts
end

def print_orig_map(input)
  puts
  puts "Original Map:"
  puts
  for r in input
    for c in r
      print c unless c == c.upcase
      print c.red if c == c.upcase
    end
    puts
  end
  puts
end

def make_points(input)
  points = Hash.new
  input.each_with_index do |x,r|
    x.each_with_index do |h,c| 
      if h == h.upcase
        points["#{r},#{c}"] = Point.new(r,c, h == "S" ? "a" : "z",h == "S" ? 0 : 99999999)
        points["#{r},#{c}"].is_start = true if h == "S"
        points["#{r},#{c}"].is_end = true if h == "E"
      else
        points["#{r},#{c}"] = Point.new(r,c,h, h=="a" ? 0:999999999) 
      end
    end
  end
  points
end

def pause
  puts "Press a key"
  gets
end

def silver(input)
  points=make_points(input)
  print_map(points)

  unvisited = []

  start = points.select{|k,p| p.height=="a".to_i(36)}
  unvisited += start.values

  loop do
    current = unvisited.min_by{|n| n.distance}
    puts "current #{current}"
    return current.distance if current.is_end

    puts "make neighbors"
    neighbors = [
      points[current.up],
      points[current.down],
      points[current.left],
      points[current.right]
    ].reject(&:nil?).each{|n| puts n}.reject{|n| 
      n.height > current.height+1 and !n.visited
    }

    puts "neighbors"
    neighbors.each{|n| puts n}

    neighbors.each do |node|
      unvisited << node
      node.distance = current.distance+1 if current.distance+1<node.distance
    end

    current.visited=true

    unvisited.delete_if{|n| n.visited}
    puts "unvisited"
    unvisited.each{|n| puts n}

    break if unvisited.empty?
    # pause
  end

  "done"
end

def gold(input)
  for i in input
    puts i
  end

  "done"
end


# Main execution
# @input = read_file_and_chomp(
@input = read_file_to_array_of_single_char(
  case ARGV[0]
  when "silver"
    "silver.txt"
  when "gold"
    "gold.txt"
  else
    "example.txt"
  end
)

puts "Silver: #{silver(@input)}"
# puts "Gold: #{gold(@input)}"
