require_relative '../../helpers'
require 'io/console'
require 'set'
DEBUG = false
class Rock
  include Comparable

  attr_reader :label

  def initialize(label)
    @label = label
  end

  def <=>(other)
    puts "Compare #{self.label} to #{other.label}"

    # ["#", "."]
    # ["#", "0"]
    # [".", "#"]
    # [".", "0"]
    # ["0", "#"]
    # ["0", "."]

    return 0 if self.label == other.label
    return 0 if self.label == '#' and other.label == '.'
    return 0 if self.label == '#' and other.label == 'O'
    return 0 if self.label == '.' and other.label == '#'
    return 1 if self.label == '.' and other.label == 'O'
    return 0 if self.label == 'O' and other.label == '#'
    return -1 if self.label == 'O' and other.label == '.'
    throw "No case for #{self.label} <=> #{other.label}"
  end

  def inspect
    "#{self.label}"
  end
  def to_s
    "#{self.label}"
  end
end

class Field
  attr_reader :field

  def initialize(raw_input)
    @field = []
    
    build_field(raw_input)
  end

  def print_field
    @field.each do |row|
      row.each do |rock|
        print rock.label
      end
      puts
    end
  end

  def cycle

  end

  def tilt_north
    @field = @field.transpose
    puts "tilt time".red if DEBUG
    # guess we do this manually
    row, col = [0,0]
    loop do
      puts "working row at #{row} which is #{@field[row]}" if DEBUG
      change = false
      col=0
      loop do
        puts "working on col at #{col} which is #{@field[row][col]}" if DEBUG
        puts "  which will compare #{@field[row][col]} to #{@field[row][col+1]}" if DEBUG
        if @field[row][col].label == '.' and @field[row][col+1].label == 'O'
          puts "need to move" if DEBUG
          change = true
          temp = @field[row][col]
          @field[row][col] = @field[row][col+1]
          @field[row][col+1] = temp
        end
        col += 1 
        break if col >= @field[0].length-1
      end
      row += 1 unless change
      break if row >= @field.length
    end

    @field = @field.transpose
  end

  def load
    @field = @field.transpose

    l = 0

    @field.each_with_index do |row, r_idx|
      puts "Working on row #{row}" if DEBUG
      weight = row.length
      row.each_with_index do |col, c_idx|
        puts "working on #{col}" if DEBUG
        # puts "no longer an O, move on" if col.label != 'O'
        # break if col.label != 'O'

        puts "adding #{weight}" if col.label == 'O' if DEBUG
        l += weight if col.label == 'O'
        weight -= 1
      end
    end

    @field = @field.transpose
    l
  end

  def to_s
    @field[0].map {|r| r.label}.join
  end

  private

  def build_field(raw_input)
    raw_input.each do |line|
      row = []
      line.chars.each { |r| row << Rock.new(r) }
      @field << row
    end
  end
end

class AOC
  def self.silver(lines)
    0
  end

  def self.gold(lines)
    0
  end
end
