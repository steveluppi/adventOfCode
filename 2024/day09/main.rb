require_relative '../../helpers'
require 'io/console'
require 'set'

$debug = false


class AOC
  def self.silver(lines)
    filesystem = []
    blocks = []
    line = lines.first.split('')
    loop do 
      break if line.empty?
      blocks << line.shift(2).map(&:to_i)
    end

    blocks.each_with_index do |b,i|
      blocks[i][0].to_i.times {|t| filesystem << i}
      blocks[i][1].to_i.times {|t| filesystem << '.'}
    end

    # debug filesystem.join
    working_at = 0
    pulling_from = filesystem.length-1
    # debug working_at, pulling_from

    loop do
      $debug=true if working_at > 49915
      # $debug=false if working_at > 50000
      debug "Loop iteration start with #{working_at} and #{pulling_from}"
      break if working_at > pulling_from
      
      loop do
        break unless filesystem[pulling_from] == '.'
        pulling_from -=1
      end
      break if working_at > pulling_from

      debug "  Loop iteration is now #{working_at} and #{pulling_from}"

      if filesystem[working_at] == '.'
        debug "Actually move things from #{pulling_from} to #{working_at} which is #{filesystem[pulling_from]}"
        filesystem[working_at] = filesystem[pulling_from]
        filesystem[pulling_from] = '.'
        pulling_from -= 1
        # debug filesystem.join
      end
      working_at += 1
    end
    # debug filesystem

    $sum = 0
    puts
    filesystem.each_with_index do |v, i|
      # print v=='.' ? '.'.green : '#'.red 
      $sum += (v*i) unless v == '.'
    end
    puts

    # idx = filesystem.index('.')
    # puts "First . is at #{idx}"
    # for n in 0..5 do
    #   puts "Index #{idx+n} is #{filesystem[idx+n]}"
    # end

    p $sum
    $sum
  end

  def self.silver_clever(lines)
    blocks = []
    line = lines.first.split('')
    loop do 
      break if line.empty?
      blocks << line.shift(2).map(&:to_i)
    end

    at_index = 0
    last_index = blocks.length-1
    puts "We start with 0 and goto #{last_index}"
    
    filesys = []
    filler = []

    loop do
      debug "Doing the loop at #{at_index} and working from #{last_index}".green

      if at_index > last_index
        debug "So we add the rest of the filler"
        filesys.concat(filler)
        break
      end

      work = []
      # add the blocks
      blocks[at_index][0].times { |i| work << at_index.to_s }
      debug "  Adding the blocks makes #{work}"

      # fill the gaps
      debug "  Filler needs to be #{blocks[at_index][1]}"
      loop do
        break if filler.length > blocks[at_index][1]
        blocks[last_index][0].times {|i| filler.unshift last_index.to_s}
        last_index -= 1
        debug "  ...filler is now #{filler}"
      end

      if at_index > last_index
        debug "So we add the rest of the filler"
        filesys.concat(filler)
        break
      end

      debug "  Time to fill in gaps"

      # fill the gaps with bits from the end
      blocks[at_index][1].times {|i| work << filler.pop }

      debug "  ... work is now #{work} after iteration".red
      debug "      leaving #{filler} behind"

      # save our work
      filesys.concat(work)
      debug "Filesystem is #{filesys}".green

      at_index += 1
    end

    $checksum=0
    puts
    filesys.map(&:to_i).each_with_index do |v, i|
      # puts "Checksum at #{i} is #{v} is #{v*i}"
      print v=='.' ? '.'.green : '#'.red
      $checksum += v*i
    end
    puts

    p $checksum
    $checksum
  end

  def self.gold(lines)
    fs = []
    blocks = []
    line = lines.first.split('')
    loop do 
      break if line.empty?
      blocks << line.shift(2).map(&:to_i)
    end

    # build fs
    blocks.each_with_index do |v, i|
      fs << Block.new(v[0], i)
      fs << Gap.new(v[1], i) unless v[1].nil?
    end
    # AOC.print_fs fs

    max_index = fs.map{|i| i.idx}.max

    for at in (max_index..0).step(-1) do
      # find the file we want to move
      to_move = fs.rindex{|i| i.is_a? Block and i.untouched?}
      # p fs[to_moe]
      debug "We want to work on #{fs[to_move]}"
      move_to = fs.index{|i| i.is_a? Gap and i.size >= fs[to_move].size}
      if move_to.nil? or move_to > to_move
        fs[to_move].touch
        next
      end
      debug "  and move it to #{fs[move_to].inspect}"
      file = fs.slice!(to_move)
      fs.insert(to_move, Gap.new(file.size, file.idx))
      gap_to_fill = fs.slice!(move_to)
      fs.insert(move_to, Gap.new(gap_to_fill.size-file.size, gap_to_fill.idx)) if gap_to_fill.size>file.size
      fs.insert(move_to, file)
      # AOC.print_fs fs
    end

    # calc checksum
    $sum = 0
    $final = []
    fs.each do |bit|
      bit.size.times {|t| $final<<bit}
    end
    $final.each_with_index do |b, i|
      $sum += b.idx*i if b.is_a? Block
    end

    $sum
  end

  def self.print_fs fs
    fs.each do |bit|
      bit.size.times {|t| print bit}
    end
    puts
  end
end
class Bit
  attr_reader :size
  attr_reader :idx
  attr_reader :touch

  def initialize(s, i)
    @size = s
    @idx = i
    @touch = false
  end
  def touch
    @touch=true
  end
  def untouched?
    @touch == false
  end
end
class Block < Bit
  def inspect
    "B of #{size}"
  end
  def to_s
    "#{@idx}".red
  end
end
class Gap < Bit
  def inspect
    "G of #{size}"
  end
  def to_s
    ".".green
  end
end
def dump
    loop do
      break if at >= blocks.length
      debug "Adding in the blocks from the #{at} which is #{blocks[at]}"
      blocks[at][0].to_i.times {|t| fs << at}
      gap = blocks[at][1]
      loop do
        break if gap==0
        debug "  Looking to fill the gap of #{gap}"
        ridx = blocks.rindex {|b| b[0]<=gap}
        break if ridx.nil?
        debug "    which can be filled from index #{ridx} which is #{blocks[ridx]}"
        block_to_move = blocks.slice!(ridx)
        block_to_move[0].to_i.times {|t| fs << ridx}
        gap -= block_to_move[0].to_i
      end
      gap.times {|t| fs << '.'}
      
      at += 1
      puts
      fs.each_with_index do |v, i|
        # puts "Checksum at #{i} is #{v} is #{v*i}"
        print v == '.' ? '.'.green : "#{v}".red
      end
      puts
    end

end
