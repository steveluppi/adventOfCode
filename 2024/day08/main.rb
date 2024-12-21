require_relative '../../helpers'
require 'io/console'
require 'set'
$debug = false

class Node < Location
  attr_reader :frequency

  def initialize(x,y,frequency)
    @x=x
    @y=y
    @frequency = frequency
  end

  def inspect
    "Node #{@frequency}: [#{@x}, #{@y}]"
  end
end

class Antinode < Location
  def inspect
    "AntiNode[#{@x}, #{@y}]"
  end

  def ==(other)
    @x==other.x and @y==other.y
  end
end

class AOC
  def self.print_grid(n, a)
    for x in 0..$max_x-1
      for y in 0..$max_y-1
        ns = n.filter{|node|node.x == x and node.y ==y}
        as = a.filter{|node|node[0] == x and node[1] ==y}
        if !as.empty?
          print "#".red
        elsif !ns.empty?
          print "#{ns.first.frequency}".green
        else
          print "•"
        end
      end
      puts
    end
  end

  def self.in_bounds(x,y)
    (x>=0 and x<$max_x and y>=0 and y<$max_y)
  end

  def self.silver(lines)
    $max_x = lines.length
    $max_y = lines[0].length
    nodes = []
    anti = Set.new
    frequencies = Set.new

    lines.each_with_index do |line, x|
      line.split('').each_with_index do |l, y|
        nodes << Node.new(x, y, l) unless l=='.'
      end
    end
    nodes.each { |n| frequencies << n.frequency }

    frequencies.each do |freq|
      n = nodes.filter{|n| n.frequency==freq}
      loop do
        on = n.shift
        debug "Working on #{on}"

        n.each do |other|
          debug "  against #{other}"
          xd = on.x - other.x
          yd = on.y - other.y

          debug "  gives us #{xd}, #{yd}"

          anti << [on.x+xd, on.y+yd] if AOC.in_bounds(on.x+xd, on.y+yd)
          anti << [other.x-xd, other.y-yd] if AOC.in_bounds(other.x-xd, other.y-yd)
        end

        break if n.length == 1
      end
    end

    anti.each{|a| p a }
    anti.size
  end

  def self.gold(lines)
    $max_x = lines.length
    $max_y = lines[0].length
    nodes = []
    anti = Set.new
    frequencies = Set.new

    lines.each_with_index do |line, x|
      line.split('').each_with_index do |l, y|
        nodes << Node.new(x, y, l) unless l=='.'
      end
    end
    nodes.each { |n| frequencies << n.frequency }

    frequencies.each do |freq|
      n = nodes.filter{|n| n.frequency==freq}
      loop do
        on = n.shift
        debug "Working on #{on}"

        n.each do |other|
          debug "  against #{other}"
          xd = on.x - other.x
          yd = on.y - other.y

          debug "  gives us #{xd}, #{yd}"

          currx = on.x 
          curry = on.y
          loop do 
            break unless AOC.in_bounds(currx+xd, curry+yd)
            anti << [currx+xd, curry+yd]
            currx += xd
            curry += yd
          end

          currx = other.x
          curry = other.y
          loop do 
            break unless AOC.in_bounds(currx-xd, curry-yd)
            anti << [currx-xd, curry-yd]
            currx -= xd
            curry -= yd
          end
        end

        break if n.length == 1
      end
    end

    nodes.each {|n| anti<<[n.x, n.y]}
    anti.size
  end
end
