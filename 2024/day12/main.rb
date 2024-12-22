require_relative '../../helpers'
require 'io/console'
require 'set'

$debug = true

class Plant < Location
  attr_reader :letter

  def initialize(x,y,l)
    @x = x
    @y = y
    @letter = l
  end

  def to_s
    "Plant #{@letter} at [#{@x},#{@y}]"
  end
  def inspect
    "Plant #{@letter} at [#{@x},#{@y}]"
  end

  def adjacent? o
    (@x==o.x and (@y == o.y-1 or @y == o.y+1)) or (@y == o.y and (@x == o.x-1 or @x == o.x+1))
  end
end

class Plot
  attr_reader :letter
  attr_reader :plants

  def initialize(l)
    @letter = l
    @plants = []
  end

  def area
    @plants.size
  end
  
  def perimeter
    @plants.map do |plant|
      up = @plants.find{|pl| pl.x == plant.x-1 and pl.y==plant.y}
      dn = @plants.find{|pl| pl.x == plant.x+1 and pl.y==plant.y}
      lf = @plants.find{|pl| pl.x == plant.x and pl.y==plant.y-1}
      ri = @plants.find{|pl| pl.x == plant.x and pl.y==plant.y+1}
      [up, dn, lf, ri].filter{|n| n.nil?}.size
    end.sum
  end

  def price
    area * perimeter
  end

  def outside_corners
    @plants.map do |plant|
      p1 = @plants.find{|pl| pl.x == plant.x-1 and pl.y==plant.y-1}
      p2 = @plants.find{|pl| pl.x == plant.x-1 and pl.y==plant.y+0}
      p3 = @plants.find{|pl| pl.x == plant.x-1 and pl.y==plant.y+1}
      p4 = @plants.find{|pl| pl.x == plant.x+0 and pl.y==plant.y-1}
      p5 = @plants.find{|pl| pl.x == plant.x+0 and pl.y==plant.y+1}
      p6 = @plants.find{|pl| pl.x == plant.x+1 and pl.y==plant.y-1}
      p7 = @plants.find{|pl| pl.x == plant.x+1 and pl.y==plant.y+0}
      p8 = @plants.find{|pl| pl.x == plant.x+1 and pl.y==plant.y+1}

      c1 = (p1.nil? and p2.nil? and p4.nil?)
      c2 = (p2.nil? and p3.nil? and p5.nil?)
      c3 = (p4.nil? and p6.nil? and p7.nil?)
      c4 = (p5.nil? and p7.nil? and p8.nil?)

      # i1 = ((!p1.nil? and p2.nil?) or (!p1.nil? and p4.nil?) or (p1.nil? and !p4.nil? and !p2.nil?))
      # i2 = ((!p3.nil? and p2.nil?) or (!p3.nil? and p5.nil?) or (p3.nil? and !p2.nil? and !p5.nil?))
      # i3 = ((!p6.nil? and p4.nil?) or (!p6.nil? and p7.nil?) or (p6.nil? and !p4.nil? and !p7.nil?))
      # i4 = ((!p8.nil? and p5.nil?) or (!p8.nil? and p7.nil?) or (p8.nil? and !p7.nil? and !p5.nil?))
      #
      # [c1, c2, c3, c4, i1, i2, i3, i4].filter{|n| n}.size
      [c1, c2, c3, c4].filter{|n| n}.size
    end.sum
  end

  def inside_corners
    @plants.map do |plant|
      p1 = @plants.find{|pl| pl.x == plant.x-1 and pl.y==plant.y-1}
      p2 = @plants.find{|pl| pl.x == plant.x-1 and pl.y==plant.y+0}
      p3 = @plants.find{|pl| pl.x == plant.x-1 and pl.y==plant.y+1}
      p4 = @plants.find{|pl| pl.x == plant.x+0 and pl.y==plant.y-1}
      p5 = @plants.find{|pl| pl.x == plant.x+0 and pl.y==plant.y+1}
      p6 = @plants.find{|pl| pl.x == plant.x+1 and pl.y==plant.y-1}
      p7 = @plants.find{|pl| pl.x == plant.x+1 and pl.y==plant.y+0}
      p8 = @plants.find{|pl| pl.x == plant.x+1 and pl.y==plant.y+1}

      # 1 2 3
      # 4   5
      # 6 7 8
      #
      # AAAA
      #  AA
      # AAAA
      i1 = (p1.nil? and !p4.nil? and !p2.nil?)
      i2 = (p3.nil? and !p2.nil? and !p5.nil?)
      i3 = (p6.nil? and !p4.nil? and !p7.nil?)
      i4 = (p8.nil? and !p5.nil? and !p7.nil?)

      [i1, i2, i3, i4].filter{|n| n}.size
    end.sum
  end

  def kitty_corners
    @plants.map do |plant|
      p1 = @plants.find{|pl| pl.x == plant.x-1 and pl.y==plant.y-1}
      p2 = @plants.find{|pl| pl.x == plant.x-1 and pl.y==plant.y+0}
      p3 = @plants.find{|pl| pl.x == plant.x-1 and pl.y==plant.y+1}
      p4 = @plants.find{|pl| pl.x == plant.x+0 and pl.y==plant.y-1}
      p5 = @plants.find{|pl| pl.x == plant.x+0 and pl.y==plant.y+1}
      p6 = @plants.find{|pl| pl.x == plant.x+1 and pl.y==plant.y-1}
      p7 = @plants.find{|pl| pl.x == plant.x+1 and pl.y==plant.y+0}
      p8 = @plants.find{|pl| pl.x == plant.x+1 and pl.y==plant.y+1}

      i1 = (!p1.nil? and p2.nil? and p4.nil?)
      i2 = (!p3.nil? and p2.nil? and p5.nil?)
      i3 = (!p6.nil? and p4.nil? and p7.nil?)
      i4 = (!p8.nil? and p5.nil? and p7.nil?)

      [i1, i2, i3, i4].filter{|n| n}.size
    end.sum
  end

  def bulk_price
    area * (outside_corners + inside_corners + kitty_corners)
    # area * (outside_corners + (inside_corners / 3)+(kitty_corners))
    # area * (outside_corners + (inside_corners / 3) + (kitty_corners / 2))
  end

  def add plant
    @plants << plant
  end

  def inspect
    "Plot with #{@plants}"
  end
  def to_s
    "Plot with #{@plants}"
  end
end

class AOC
  def self.print_plots
    $plots.each {|pl| p pl}
  end

  def self.print_garden
    for x in 0..$max_x
      for y in 0..$max_y
        plant = $garden.find{|g| g.x == x and g.y == y}
        unless plant.nil?
          if plant.letter == 'R'
            print plant.letter.green
          else
            print plant.letter
          end
        end
        print "?" if plant.nil?
        # print plant.letter.green if plant.letter == 'C'
        # print '•' unless plant.letter == 'C'
      end
      puts
    end
  end

  def self.silver(lines)
    $garden = []
    $max_x = lines.length-1
    $max_y = lines.first.split('').length-1

    lines.each_with_index do |line, x|
      line.split('').each_with_index do |l, y|
        $garden << Plant.new(x, y, l)
      end
    end
    # AOC.print_garden

    # make plots?
    $plots = []

    $garden.each do |plant|
      # print "checking "
      # p plant
      # find all plots with this letter
      matched_plots = $plots.filter { |pl| pl.letter == plant.letter }
      # print "matched plots "
      # debugp matched_plots

      if matched_plots.empty?
        # no matched plot, let's create one!
        # puts "no matched plots".red
        plot = Plot.new(plant.letter)
        plot.add plant

        $plots << plot
      elsif matched_plots.length == 1
        # puts "found one plot"
        if matched_plots.first.plants.any? { |pl| pl.adjacent?(plant) }
          # puts "with adjacents".green
          #it fits, add it in
          # puts "   so adding plant"
          matched_plots.first.add plant
        else
          # it didnt fit, make a new plot
          # puts "without adjacents".red
          plot = Plot.new(plant.letter)
          plot.add plant

          $plots << plot
        end
      else
        # we found more than one
        the_plot = matched_plots.find do |plot|
          plot.plants.any? {|pl| plant.adjacent? pl}
        end

        if the_plot.nil?
          # none existed, add a new one
          plot = Plot.new(plant.letter)
          plot.add plant

          $plots << plot
        else
          # the plot was found, add it
          the_plot.add plant
        end
      end
    end
    # AOC.print_plots
    
    # need to consolidate plots? Ugh
    for i in ($plots.length-1..0).step(-1) do 
      work = $plots[i]
      others = $plots.filter{|pl| pl.letter == work.letter and pl != work}
      # puts "looking at plot #{work} at #{i} against #{others}"
      # puts
      match = others.find {|o| o.plants.any? {|pl| work.plants.any?{|wp| wp.adjacent? pl}}}
      unless match.nil?
        # puts "  with match #{match}".green
        work.plants.each {|pl| match.add pl}
        $plots.delete_at(i)
      else
        # puts "  without match".red
      end
    end

    # $plots.each {|pl| puts "A region of #{pl.letter} plants with price #{pl.area} * #{pl.perimeter} = #{pl.price}" }

    # puts 
    # $plots.filter{|pl| pl.letter == 'C'}.each {|pl| puts pl}
    puts
    # AOC.print_garden
    # $plots.each {|pl| puts "Letter #{pl.letter}, oc, ic #{pl.outside_corners}, #{pl.inside_corners/3}, #{pl.kitty_corners} = #{(pl.outside_corners + pl.inside_corners/3 + pl.kitty_corners)}" }
    # $plots.each {|pl| puts "Letter #{pl.letter}, oc, ic #{pl.outside_corners}, #{pl.inside_corners} = #{(pl.outside_corners + pl.inside_corners)}" }
    p $plots.map(&:bulk_price).sum
    $plots.map(&:bulk_price).sum
  end

  def self.gold(lines)
  end
end
