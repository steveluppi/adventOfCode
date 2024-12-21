require_relative '../../helpers'
require 'io/console'
require 'set'

class Robot < Location
  attr_reader :vx, :vy

  def initialize(x, y, vx, vy)
    @x = x
    @y = y
    @vx = vx
    @vy = vy
  end

  def move
    @x = (@x + @vx) % $mx
    @y = (@y + @vy) % $my
  end

  def inspect
    "R[#{x}, #{y}]"
  end
end

class AOC
  def self.print_grid
    for x in 0..($my-1)
      for y in 0..($mx-1)
        c = $bots.filter{|b|b.x == x and b.y==y}.count
        print '⬜️' if c.zero?
        # print '🤖' unless c.zero?
        print '🎄' unless c.zero?
      end
      puts
    end
  end

  def self.silver(lines)
    $mx = 101
    $my = 103
    $bots = []

    lines.each do |line|
      s=line.gsub('p=','').gsub('v=','').split(' ')
      x,y = s[0].split(',').map(&:to_i)
      vx,vy = s[1].split(',').map(&:to_i)
      $bots << Robot.new(x,y,vx,vy)
    end

    AOC.print_grid

    100.times {|t| $bots.each(&:move) }
    puts

    AOC.print_grid

    q1 = $bots.filter { |b| b.x < $mx/2 and b.y < $my/2 }.size
    q2 = $bots.filter { |b| b.x > $mx/2 and b.y < $my/2 }.size
    q3 = $bots.filter { |b| b.x < $mx/2 and b.y > $my/2 }.size
    q4 = $bots.filter { |b| b.x > $mx/2 and b.y > $my/2 }.size
    p q1, q2, q3, q4

    q1*q2*q3*q4
  end

  def self.gold(lines)
    $mx = 101
    $my = 103
    $bots = []

    lines.each do |line|
      s=line.gsub('p=','').gsub('v=','').split(' ')
      x,y = s[0].split(',').map(&:to_i)
      vx,vy = s[1].split(',').map(&:to_i)
      $bots << Robot.new(x,y,vx,vy)
    end

    $count = 0
    loop do
      print "\r#{$count} seconds have passed"
      break if AOC.is_sym_gps?
      $count +=1
      $bots.each(&:move)
    end

    AOC.print_grid

    p $count
    $count
  end

  def self.has_tree?
    tree = $bots.find do |bot|
      bot_x = bot.x
      bot_y = bot.y
      puts
      puts "Found tree at #{bot_x}, #{bot_y}"
      good = true
      for row in (bot_x+1)..$mx do
        # iterate down each row
        # starting with directly under the tree
        under = $bots.find{|b| b.x==row and b.y==bot_y}
        puts "Under is #{under}, #{under.nil?}"
        if under.nil? and row <= bot_x+1
          puts "Breaking with false"
          good = false
          break
        elsif under.nil? and row > bot_x+1 # if we hit an empty space, return true
          puts "Breaking with true? #{good}"
          break
        end

        sym = true
        for col in 1..$my do
          left = $bots.find{|b| b.x==row and b.y==bot_y-col}
          right = $bots.find{|b| b.x==row and b.y==bot_y+col}
          break if left.nil? and right.nil?
          next if left.is_a? Robot and right.is_a? Robot
          
          sym=false
          break
        end
        next false unless sym
      end
    end

    return false if tree.nil?
    
    true
  end

  def self.is_sym_gps?
    q1 = $bots.filter { |b| b.x < $mx/2 and b.y < $my/2 }.size
    q2 = $bots.filter { |b| b.x > $mx/2 and b.y < $my/2 }.size
    q3 = $bots.filter { |b| b.x < $mx/2 and b.y > $my/2 }.size
    q4 = $bots.filter { |b| b.x > $mx/2 and b.y > $my/2 }.size

    (q1==q2 and q3==q4)
  end

  def self.is_sym?
    for y in 0..($my-1)
      line = ''
      for x in 0..($mx-1)
        c = $bots.filter{|b|b.x == x and b.y==y}.count
        line << ' ' if c.zero?
        line << 'b' unless c.zero?
      end
      # p line
      # p line=~ /^\ *b*\ *$/
      if line =~ /^\ *b*\ *$/
        # symentrical , do nothing
      else
        #not symetrical do something
        return false
      end
    end
    true
  end
end

# AOC.silver(read_file_and_chomp('silver.txt'))
