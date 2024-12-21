require_relative '../../helpers'
require 'io/console'
require 'set'

class Robot < Location
  def inspect
    "Robot"
  end
  def left
    @y-=1
  end
  def right
    @y+=1
  end
  def up
    @x-=1
  end
  def down
    @x+=1
  end
end

class Box < Location
  def inspect
    "Box"
  end

  def gps
    100*@x + @y
  end

  def left
    @y-=1
  end
  def right
    @y+=1
  end
  def up
    @x-=1
  end
  def down
    @x+=1
  end
end

class Wall < Location
  def inspect
    "Wall"
  end
end

class AOC
  def self.print_grid
    for x in 0..$mx do
      for y in 0..$my do
        l = $grid.find{|b| b.x==x and b.y==y}
        case l
        when Wall 
          print '#'.red
        when Box
          print 'O'
        when Robot
          print '@'.green
        else
          print '•'
        end
      end
      puts
    end
  end

  def self.silver(lines)
    $grid = []
    $mx = 0
    loop do
      line = lines[$mx]
      break if line.empty?
      $my = line.split('').length-1
      line.split('').each_with_index do |l,y|
        case l
        when '#'
          $grid << Wall.new($mx,y)
        when 'O'
          $grid << Box.new($mx, y)
        when '@'
          $grid << Robot.new($mx, y)
        end
      end
      $mx += 1
    end
    $mx-=1
    puts "we have a grid of #{$mx},#{$my}"
    AOC.print_grid

    puts 

    instructions = lines[($mx+2)..].join('')
    puts instructions
    puts
    bot = $grid.find{|g| g.is_a? Robot}
    instructions.split('').each do |i|
      # puts
      # AOC.print_grid
      # puts
      bx = bot.x
      by = bot.y
      case i
      when '^'
        # puts 'up'
        bx-=1
        to_shift = []
        for x in (bx..0).step(-1) do
          # puts "checking #{x},#{by}"
          at = $grid.find{|t|t.x==x and t.y==by}
          # puts "found #{at.inspect}"

          break if at.is_a? Wall

          to_shift << at if at.is_a? Box
          if at.nil?
            # we have a gap, lets shift
            to_shift.each(&:up)
            bot.up
            break
          end
        end
      when 'v'
        # puts 'down'
        bx+=1
        to_shift = []
        for x in (bx..$mx) do
          # puts "checking #{x},#{by}"
          at = $grid.find{|t|t.x==x and t.y==by}
          # puts "found #{at.inspect}"

          break if at.is_a? Wall

          to_shift << at if at.is_a? Box
          if at.nil?
            # we have a gap, lets shift
            to_shift.each(&:down)
            bot.down
            break
          end
        end
      when '<'
        # puts 'left'
        by-=1
        to_shift = []
        for y in (by..0).step(-1) do
          # puts "checking #{bx},#{y}"
          at = $grid.find{|t|t.x==bx and t.y==y}
          # puts "found #{at.inspect}"

          break if at.is_a? Wall

          to_shift << at if at.is_a? Box
          if at.nil?
            # we have a gap, lets shift
            to_shift.each(&:left)
            bot.left
            break
          end
        end
      when '>'
        # puts 'right'
        by+=1
        to_shift = []
        for y in (by..$my) do
          # puts "checking #{bx},#{y}"
          at = $grid.find{|t|t.x==bx and t.y==y}
          # puts "found #{at.inspect}"

          break if at.is_a? Wall

          to_shift << at if at.is_a? Box
          if at.nil?
            # we have a gap, lets shift
            to_shift.each(&:right)
            bot.right
            break
          end
        end
      else 
        puts "well this is real broken"
        p i
        exit
      end
    end
    puts
    AOC.print_grid
    puts

    # time to calc GPS
    $grid.filter{|b|b.is_a? Box}.map(&:gps).sum
  end

  def self.gold(lines)
  end
end
