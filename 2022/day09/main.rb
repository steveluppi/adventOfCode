# Advent of Code - Day x
require_relative "../helpers"
require 'set'

def visualize(head,tail,grid)
  return
  for y in (5..0).step(-1)
    for x in (0..5)
      if head.match?(x,y)
        print "H"
      elsif tail.match?(x,y)
        print "T"
      else
        print "."
      end
    end
    puts
  end
end

class Coord
  attr_accessor :x
  attr_accessor :y

  @visited = false
  @x
  @y

  def initialize(x,y)
    @x=x
    @y=y
    @visited=false
  end

  def visit
    @visited=true
  end

  def setCoord(x,y)
    @x=x
    @y=y
  end

  def match?(x,y)
    @x==x && @y==y
  end
  def visited?
    @visited
  end
  def eql?(obj)
    @x==obj.x && @y == obj.y
  end
  def hash
    [@x,@y].hash
  end
  # def to_str
  #   "[#{@x},#{@y}]#{@visited?'√':'ø'}"
  # end
  def to_s
    "[#{@x},#{@y}]#{@visited?'√':'ø'}"
  end

  def up
    @y+=1
  end
  def down
    @y-=1
  end
  def right
    @x+=1
  end
  def left
    @x-=1
  end
  def follow(head)
    puts "\thead: #{head}"
    puts "\tself: #{self}"
    if (self.x-1..self.x+1).include?(head.x) && (self.y-1..self.y+1).include?(head.y)
      puts "\t\tsafe"
    else
      if head.y==self.y && head.x>self.x
        puts "\t\tFollow right"
        self.right
      elsif head.x==self.x && head.y>self.y+1
        puts "\t\tfollow up"
        self.up
      elsif head.y==self.y && head.x<self.x-1
        puts "\t\tFollow left"
        self.left
      elsif head.x==self.x && head.y<self.y-1
        puts "\t\tFollow down"
        self.down
      elsif head.y>self.y && head.x>self.x
        puts "\t\tFollow up and right"
        self.right
        self.up
      elsif head.y>self.y && head.x<self.x
        puts "\t\tFollow up and left"
        self.up
        self.left
      elsif head.y<self.y && head.x<self.x
        puts "\t\tFollow down and left"
        self.down
        self.left
      elsif head.y<self.y && head.x>self.x
        puts "\t\tFollow down and right"
        self.down
        self.right
      end
    end
    puts "\thead: #{head}"
    puts "\tself: #{self}"
  end
end

def doVisit(grid, tail)
  x=grid.find{|c| c.match?(tail.x,tail.y)}
  x.visit unless x.nil?
end

def silver(input)
  grid = Set.new()
  grid.add(Coord.new(0,0))
  head = Coord.new(0,0)
  tail = Coord.new(0,0)
  # tails = Array.new(9){Coord.new(0,0)}
  doVisit(grid,head)

  visualize(head,tail,grid)
  for i in input
    direction, count = i.split(' ')
    puts "#{direction}, #{count}"
    case direction
    when "R"
      count.to_i.times do |j|
        puts "go right"
        # take that action
        head.right
        # make sure that point is in the grid
        grid.add(head.clone)
        # have the tail follow if needed
        tail.follow(head)
        # make sure the tail positon is visited
        doVisit(grid,tail)
        visualize(head,tail,grid)
      end
    when "L"
      count.to_i.times do |j|
        puts "go left"
        head.left
        grid.add(head.clone)
        tail.follow(head)
        doVisit(grid,tail)
        visualize(head,tail,grid)
      end
    when "U"
      count.to_i.times do |j|
        puts "go up"
        head.up
        grid.add(head.clone)
        tail.follow(head)
        doVisit(grid,tail)
        visualize(head,tail,grid)
      end
    when "D"
      count.to_i.times do |j|
        puts "go down"
        head.down
        grid.add(head.clone)
        tail.follow(head)
        doVisit(grid,tail)
        visualize(head,tail,grid)
      end
    else 
      p "WTF"
    end
  end

  grid.select{|c|c.visited?}.length
end

def gold(input)
  for i in input
    puts i
  end

  "done"
end


# Main execution
@input = read_file_and_chomp(
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
