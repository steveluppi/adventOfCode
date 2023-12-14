require_relative '../../helpers'
# require 'io/console'
# require 'set'

DEBUG = false

class Thing
  attr_reader :label

  def initialize(label)
    @label = label
  end

  def inspect
    "#{self.label}"
  end

  def to_s
    "#{self.label}"
  end
end

class AOC
  def self.solve(puzzle)
    puts if DEBUG
    puts "Solve puzzle" if DEBUG
    puzzle.each { |x| p x } if DEBUG
    # do rows first
    rows = 0
    (0..puzzle.length-2).each do |row|
      puts "checking puzzle row #{row}" if DEBUG
      puts "  #{puzzle[row]} to" if DEBUG
      puts "  #{puzzle[row+1]}" if DEBUG
      if puzzle[row] == puzzle[row+1]
        i = row
        j = row+1
        same = true
        loop do
          puts if DEBUG
          puts "compare" if DEBUG
          puts puzzle[i] if DEBUG
          puts puzzle[j] if DEBUG
          puts if DEBUG
          same = false unless puzzle[i] == puzzle[j]
          break unless same
          i-=1
          j+=1
          break if i < 0 or j >= puzzle.length
        end
        rows += row+1 if same
      end
    end
    
    puts "Found #{rows} to be mirrored" if DEBUG

    # transpose and do cols
    cols = 0
    puzzle = puzzle.map{|r| r.chars}.transpose
    puzzle.map!{|r| r.join}
    (0..puzzle.length-2).each do |col|
      puts "checking puzzle col #{col}" if DEBUG
      puts "  #{puzzle[col]} to" if DEBUG
      puts "  #{puzzle[col+1]}" if DEBUG
      if puzzle[col] == puzzle[col+1]
        i = col
        j = col+1
        same = true
        loop do
          puts if DEBUG
          puts "compare" if DEBUG
          puts puzzle[i] if DEBUG
          puts puzzle[j] if DEBUG
          puts if DEBUG
          same = false unless puzzle[i] == puzzle[j]
          break unless same
          i-=1
          j+=1
          break if i < 0 or j >= puzzle.length
        end
        cols += col+1 if same
      end
    end
    
    puts "Found #{cols} to be mirrored" if DEBUG

    cols + rows*100
  end

  def self.silver(input)
    sum = 0
    puzzle = []
    input.each do |line|
      if line == ''
        sum += solve puzzle
        puzzle = []
      else
        puzzle << line
      end
    end
    sum+= solve puzzle

    sum
  end
end
