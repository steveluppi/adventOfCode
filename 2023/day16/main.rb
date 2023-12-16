require_relative '../../helpers'
require 'io/console'
require 'set'

class Field
  attr_reader :field

  def initialize(h,w)
    @h = h
    @w = w
    @field = {}
  end
  
  def add_location(location)
    @field[location.coords] = location
  end

  def in_field?(coords)
    x,y = coords
    return false if x < 0 or x > @h-1
    return false if y < 0 or y > @w-1
    true
  end

  def energy_count
    @field.values.select { |loc| loc.is_energized? }.size
  end

  def print_field
    puts
    (0..@h-1).each do |r|
      (0..@w-1).each do |c|
        print @field[[r,c]].label
      end
      puts
    end
  end

  def reset
    @field.each {|k,v| v.reset}
  end

  def print_energized
    puts
    (0..@h-1).each do |r|
      (0..@w-1).each do |c|
        loc = @field[[r,c]]
        print (loc.is_energized?) ? '#' : '.'
      end
      puts
    end
  end

  def print_beams
    puts
    (0..@h-1).each do |r|
      (0..@w-1).each do |c|
        loc = @field[[r,c]]
        if loc.is_mirror?
          print loc.label
        else
          if loc.energy_count == 1
            print '>' if loc.beams[0] == 'e' 
            print '<' if loc.beams[0] == 'w' 
            print '^' if loc.beams[0] == 'n' 
            print 'v' if loc.beams[0] == 's' 
          elsif loc.energy_count > 1
            print loc.energy_count
          else 
            print '.'
          end
        end
      end
      puts
    end
  end
end

class Location
  attr_reader :label
  attr_accessor :energy_count
  attr_reader :beams

  def initialize(label, x, y)
    @label = label
    @row = x
    @col = y
    @energized = false
    @energy_count = 0
    @beams = []
  end

  def coords
    [@row, @col]
  end

  def reset
    @energized = false
    @energy_count = 0
    @beams = []
  end

  def is_mirror?
    @label =~ /[\-\|\\\/]/
  end

  def is_energized?
    @energized
  end

  def energize(beam)
    @energized = true
    @energy_count += 1
    has_been_seen = beams.include? beam
    beams << beam

    has_been_seen
  end

  def inspect
    "Location [#{@row}, #{@col}]"
  end

  def to_s
    "Location [#{@row}, #{@col}]"
  end
end

class Beam
  attr_reader :heading
  attr_reader :in_loop

  def initialize(x,y,heading)
    @row = x
    @col = y
    @heading = heading
    @in_loop = false
  end

  def coords
    [@row, @col]
  end

  def redundant
    @in_loop = true
  end

  def travel
    case heading
    when 'n'
      @row -= 1
    when 's'
      @row += 1
    when 'w'
      @col -= 1
    when 'e'
      @col += 1
    end
  end

  def reflect(mirror)
    new_beam = nil

    case heading
    when 'n'
      case mirror
      when '/'
        @heading = 'e'
      when "\\"
        @heading = 'w'
      when '-'
        @heading = 'w'
        new_beam = Beam.new(@row, @col, 'e')
      when '|'
      end
    when 's'
      case mirror
      when '/'
        @heading = 'w'
      when "\\"
        @heading = 'e'
      when '-'
        @heading = 'w'
        new_beam = Beam.new(@row, @col, 'e')
      when '|'
      end
    when 'w'
      case mirror
      when '/'
        @heading = 's'
      when "\\"
        @heading = 'n'
      when '-'
      when '|'
        @heading = 'n'
        new_beam = Beam.new(@row, @col, 's')
      end
    when 'e'
      case mirror
      when '/'
        @heading = 'n'
      when "\\"
        @heading = 's'
      when '-'
      when '|'
        @heading = 'n'
        new_beam = Beam.new(@row, @col, 's')
      end
    end
    new_beam.travel unless new_beam.nil?
    new_beam
  end

  def inspect
    "[#{@row}, #{@col}] going #{@heading}"
  end

  def to_s
    "[#{@row}, #{@col}] going #{@heading}"
  end
end

class AOC
  DEBUG = false

  def self.putss text=''
    puts text if DEBUG
  end

  def self.ps text
    p text if DEBUG
  end

  def self.make_field(lines)
    f = Field.new(lines.length, lines[0].length)
    lines.each_with_index do |row, r_idx|
      row.chars.each_with_index do |col, c_idx|
        f.add_location Location.new(col, r_idx, c_idx)
      end
    end

    f
  end

  def self.solve(field, beams)
    loop do
      break if beams.empty?
      putss
      new_beams = []
      beams.each do |beam|
        putss "Working on beam at #{beam}"
        loc = field.field[beam.coords]
        putss "#{loc}"
        been_here_before = loc.energize beam.heading
        beam.redundant if been_here_before
        new_beams << beam.reflect(loc.label) if loc.is_mirror?
        putss "New beams is now #{new_beams}"
        beam.travel
        putss "After travel is it is now #{beam}"
      end
      beams << new_beams.compact
      beams.flatten!

      # drop beams that are no longer on the platform
      putss "Beams before drop is #{beams}"
      putss "Beams with loop #{beams.select {|b| b.in_loop }}"
      beams.select! { |b| field.in_field? b.coords and !b.in_loop }
      putss "Beams after drop is #{beams}"

      putss
      if DEBUG
        field.print_field
        field.print_energized
        field.print_beams
        # q_to_quit
      end
    end

    puts "solve with #{field.energy_count}".green
    
    field.energy_count
  end

  def self.silver(lines)
    field = make_field lines
    field.print_field
    field.print_energized
    field.print_beams
    
    beams = [Beam.new(0,0,'e')]

    solve(field, beams)
  end

  def self.gold(lines)
    field = make_field lines
    field.print_field
    field.print_energized
    field.print_beams
    
    max = nil
    (0..lines.length-1).each do |row|
      beams = [Beam.new(row, 0, 'e')]
      m1 = solve(field, beams)
      field.reset
      beams = [Beam.new(row, lines[0].length-1, 'w')]
      m2 = solve(field, beams)
      field.reset
      max = [max, m1, m2].compact.max
    end
    puts "After rows, #{max} is the max".green
    (0..lines[0].length-1).each do |col|
      beams = [Beam.new(0, col, 's')]
      m1 = solve(field, beams)
      field.reset
      beams = [Beam.new(lines.length-1, lines[0].length-1, 'n')]
      m2 = solve(field, beams)
      field.reset
      max = [max, m1, m2].max
    end
    puts "After cols, #{max} is the max".green

    max
  end

  def self.q_to_quit
    x=$stdin.getch
    exit if x == 'q'
  end
end
