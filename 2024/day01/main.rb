require_relative '../../helpers'
require 'io/console'
require 'set'

class AOC
  def self.silver(lines)
    left = []
    right=[]
    sums=[]
    lines.each do |line|
      s=line.split(' ')
      left << s[0]
      right << s[1]
    end

    left.sort!
    right.sort!

    p left, right

    left.each_with_index do |l, idx|
      sums << (l.to_i - right[idx].to_i).abs
    end

    sums.sum()
  end

  def self.gold(lines)
    left = []
    right=[]
    sums=[]
    lines.each do |line|
      s=line.split(' ')
      left << s[0]
      right << s[1]
    end

    left.sort!
    right.sort!

    p left, right

    left.each do |l|
      rc = right.filter{|r| r==l}.size
      puts "Right count of #{l} is #{rc}"
      sums << l.to_i * rc
    end

    p sums.sum
  end
end

AOC.gold(read_file_and_chomp('./example.txt'))
