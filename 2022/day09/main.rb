# Advent of Code - Day x
require_relative "../helpers"
require 'set'

def visualize(head,tails,grid)
  # for c in tails
  #   puts c
  # end
  # return
  ymin=-5
  ymax=15
  xmin=-10
  xmax=15
  puts
  for y in (ymax..ymin).step(-1)
    for x in (xmin..xmax)
      if head.match?(x,y)
        print "H"
      elsif tails.any?{|c|c.match?(x,y)}
        which=tails.find_index{|c|c.match?(x,y)}
        print "#{which+1}"
      elsif x==0 && y==0
        print "s"
      else
        print "."
      end
    end
    puts
  end
  puts
end
def visualize_visits(grid)
  return
  for y in (15..-15).step(-1)
    for x in (-15..15)
      if grid.any?{|c|c.match?(x,y)}
        print "#"
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
    # puts "\thead: #{head}"
    # puts "\tself: #{self}"
    if (self.x-1..self.x+1).include?(head.x) && (self.y-1..self.y+1).include?(head.y)
      # puts "\t\tsafe"
    else
      if head.y==self.y && head.x>self.x
        # puts "\t\tFollow right"
        self.right
      elsif head.x==self.x && head.y>self.y+1
        # puts "\t\tfollow up"
        self.up
      elsif head.y==self.y && head.x<self.x-1
        # puts "\t\tFollow left"
        self.left
      elsif head.x==self.x && head.y<self.y-1
        # puts "\t\tFollow down"
        self.down
      elsif head.y>self.y && head.x>self.x
        # puts "\t\tFollow up and right"
        self.right
        self.up
      elsif head.y>self.y && head.x<self.x
        # puts "\t\tFollow up and left"
        self.up
        self.left
      elsif head.y<self.y && head.x<self.x
        # puts "\t\tFollow down and left"
        self.down
        self.left
      elsif head.y<self.y && head.x>self.x
        # puts "\t\tFollow down and right"
        self.down
        self.right
      end
    end
    # puts "\thead: #{head}"
    # puts "\tself: #{self}"
  end
end

def doVisit(grid, tail)
  x = nil
  while x.nil? do 
    x=grid.find{|c| c.match?(tail.x,tail.y)}
    grid.add(Coord.new(tail.x,tail.y)) if x.nil?
  end
  x.visit
end
def doFollow(head,tails)
  # tails.map!.with_index do |t,idx|
  #   puts idx,tails[idx],tails[idx-1]
  #   t.follow(head) if idx==0
  #   t.follow(tails[idx-1]) unless idx==0
  # end
  tails.each_index do |idx|
    tails[idx].follow(head) if idx==0
    tails[idx].follow(tails[idx-1]) unless idx==0
  end
end

def silver(input)
  grid = Set.new()
  grid.add(Coord.new(0,0))
  head = Coord.new(0,0)
  tail = Coord.new(0,0)
  tails = Array.new(9){Coord.new(0,0)}
  doVisit(grid,tails.last)

  visualize(head,tails,grid)
  for i in input
    direction, count = i.split(' ')
    puts "#{direction}, #{count}"
    case direction
    when "R"
      count.to_i.times do |j|
        # puts "go right"
        # take that action
        head.right
        # make sure that point is in the grid
        grid.add(head.clone)
        # have the tail follow if needed
        tail.follow(head)
        doFollow(head,tails)
        visualize(head,tails,grid)
        # make sure the tail positon is visited
        doVisit(grid,tails.last)
      end
    when "L"
      count.to_i.times do |j|
        # puts "go left"
        head.left
        grid.add(head.clone)
        tail.follow(head)
        doFollow(head,tails)
        visualize(head,tails,grid)
        doVisit(grid,tails.last)
      end
    when "U"
      count.to_i.times do |j|
        # puts "go up"
        head.up
        grid.add(head.clone)
        tail.follow(head)
        doFollow(head,tails)
        visualize(head,tails,grid)
        doVisit(grid,tails.last)
      end
    when "D"
      count.to_i.times do |j|
        # puts "go down"
        head.down
        grid.add(head.clone)
        tail.follow(head)
        doFollow(head,tails)
        visualize(head,tails,grid)
        doVisit(grid,tails.last)
      end
    else 
      p "WTF"
    end
    visualize(head,tails,grid)
  end

  visualize_visits(grid)
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
