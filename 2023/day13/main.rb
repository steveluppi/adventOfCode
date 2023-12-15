require_relative '../../helpers'
# require 'io/console'
# require 'set'

DEBUG = true

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

  def self.solve_gold_broken(puzzle)
    puts if DEBUG
    puts "Solve puzzle" if DEBUG
    puzzle.each { |x| p x } if DEBUG
    # do rows first
    rows = 0
    (0..puzzle.length-2).each do |row|
      puts "checking puzzle row #{row}".red if DEBUG
      puts "  #{puzzle[row]} to".red if DEBUG
      puts "  #{puzzle[row+1]}".red if DEBUG
      top = puzzle[row].to_i(2)
      bottom = puzzle[row+1].to_i(2)
      puts "  #{top} to".red if DEBUG
      puts "  #{bottom}".red if DEBUG
      puts if DEBUG
      puts "is there a smudge?".red if DEBUG
      diff = top ^ bottom
      puts "  which is #{diff}".red if DEBUG
      puts "   #{Math.log2(diff)}".red if diff > 0 and DEBUG
      puts "   which #{Math.log2(diff) == Math.log2(diff).floor ? 'is a smudge' : 'is not a smudge' }".red if diff > 0 and DEBUG
      smudge = Math.log2(diff) == Math.log2(diff).floor if diff > 0

      if puzzle[row] == puzzle[row+1] or smudge
        i = row-1
        j = row+2
        same = true
        loop do
          puts if DEBUG
          puts "compare".red if DEBUG
          puts puzzle[i] if DEBUG
          puts puzzle[j] if DEBUG
          top = puzzle[i].to_i(2)
          bottom = puzzle[j].to_i(2)
          puts "  #{top} to".red if DEBUG
          puts "  #{bottom}".red if DEBUG
          puts if DEBUG
          puts "is there a smudge?".red if DEBUG
          diff = top ^ bottom
          puts "  which is #{diff} to #{diff.to_s(2)}".red if DEBUG
          puts "   #{Math.log2(diff)}".red if diff > 0 and DEBUG
          puts "   which #{Math.log2(diff) == Math.log2(diff).floor ? 'is a smudge' : 'is not a smudge' }".red if diff > 0 and DEBUG
          inner_smudge = Math.log2(diff) == Math.log2(diff).floor if diff > 0
          same = false if inner_smudge and smudge
          puts "too many smudges".red if inner_smudge and smudge
          smudge = true if inner_smudge
          puts "  #{top} to".red if DEBUG
          puts "  #{bottom}".red if DEBUG
          puts if DEBUG
          same = false unless puzzle[i] == puzzle[j] or inner_smudge
          break unless same
          i-=1
          j+=1
          break if i < 0 or j >= puzzle.length
        end unless i < 0 or j >= puzzle.length
        puts "ADDING mirrored for #{row}".red if DEBUG
        rows += row+1 if same and smudge
        break;
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
      top = puzzle[col].to_i(2)
      bottom = puzzle[col+1].to_i(2)
      puts "  #{top} to" if DEBUG
      puts "  #{bottom}" if DEBUG
      puts if DEBUG
      puts "is there a smudge?" if DEBUG
      diff = top ^ bottom
      puts "  which is #{diff}" if DEBUG
      puts "   #{Math.log2(diff)}" if diff > 0 and DEBUG
      puts "   which #{Math.log2(diff) == Math.log2(diff).floor ? 'is a smudge' : 'is not a smudge' }" if diff > 0 and DEBUG
      smudge = Math.log2(diff) == Math.log2(diff).floor if diff > 0

      if puzzle[col] == puzzle[col+1]
        i = col+1
        j = col+2
        same = true
        loop do
          puts if DEBUG
          puts "compare" if DEBUG
          puts puzzle[i] if DEBUG
          puts puzzle[j] if DEBUG
          top = puzzle[i].to_i(2)
          bottom = puzzle[j].to_i(2)
          puts "  #{top} to" if DEBUG
          puts "  #{bottom}" if DEBUG
          puts if DEBUG
          puts "is there a smudge?" if DEBUG
          diff = top ^ bottom
          puts "  which is #{diff} to #{diff.to_s(2)}" if DEBUG
          puts "   #{Math.log2(diff)}" if diff > 0 and DEBUG
          puts "   which #{Math.log2(diff) == Math.log2(diff).floor ? 'is a smudge' : 'is not a smudge' }" if diff > 0 and DEBUG
          inner_smudge = Math.log2(diff) == Math.log2(diff).floor if diff > 0
          same = false if inner_smudge and smudge
          puts "too many smudges" if inner_smudge and smudge
          smudge = true if inner_smudge
          puts "  #{top} to" if DEBUG
          puts "  #{bottom}" if DEBUG
          puts if DEBUG
          same = false unless puzzle[i] == puzzle[j] or inner_smudge
          break unless same
          i-=1
          j+=1
          break if i < 0 or j >= puzzle.length
        end unless i < 0 or j >= puzzle.length
        cols += col+1 if same and smudge
      end
    end

    puts "Found #{cols} to be mirrored" if DEBUG

    cols + rows*100
  end

  def self.putss(str='')
    puts str if DEBUG
  end
  def self.ps(thing)
    p thing if DEBUG
  end

  def self.has_smudge(diff)
    putss "  #{diff} --> no smudge".red if diff == 0
    return false if diff == 0

    is_smudge = Math.log2(diff) == Math.log2(diff).floor
    if is_smudge
      putss "  #{diff} --> smudge".green
    else
      putss "  #{diff} --> no smudge".red
    end
    putss "     #{Math.log2(diff)}"
    is_smudge
  end

  def self.solve_gold(puzzle)
    rows, cols = [0,0] # start with a blank count

    putss
    putss "Solve puzzle"
    puzzle.each { |x| ps x }
    putss

    (0..puzzle.length-2).each do |row|
      top_row = puzzle[row]
      bot_row = puzzle[row+1]
      putss "Row #{row}: #{top_row} <-> #{bot_row}"
      top_val = top_row.to_i(2)
      bot_val = bot_row.to_i(2)
      putss "Row #{row}: #{top_val} <-> #{bot_val}"
      diff = top_val ^ bot_val
      smudge = has_smudge diff

      if top_val == bot_val or smudge
        i = row-1
        j = row+2
        putss "We have a match or a possible smudge ... iterate #{i}, #{j}"
        same = true

        loop do 
          top_row = puzzle[i]
          bot_row = puzzle[j]
          putss "  IRow #{i}&#{j}: #{top_row} <-> #{bot_row}"
          top_val = top_row.to_i(2)
          bot_val = bot_row.to_i(2)
          putss "  IRow #{i}&#{j}: #{top_val} <-> #{bot_val}"
          diff = top_val ^ bot_val
          inner_smudge = has_smudge diff

          # if there was already a smudge
          # putss "   smudge and inner smudge #{smudge} and #{inner_smudge}"
          if smudge and inner_smudge
            putss "  We already saw a smudge, and now we see another".red
            putss "  so we have to say they are not the same".red
            same = false
          elsif inner_smudge
            putss "  We have not seen a smudge yet, so this is the first".green
            putss "  setting to true".green
            smudge = true 
          end

          break unless same
          i -= 1
          j += 1
          break if i < 0 or j >= puzzle.length
        end unless i < 0 or j >= puzzle.length
      end

      if same and smudge
        putss "Found same and had a smudge. Yay!".green
        rows += row+1
        break
      end
    end

    if rows == 0
      # putss "We did not find any rows, so check columns"
      puzzle = puzzle.map{|r| r.chars}.transpose
      puzzle.map!{|r| r.join}
      (0..puzzle.length-2).each do |col|
        top_col = puzzle[col]
        bot_col = puzzle[col+1]
        putss "col #{col}: #{top_col} <-> #{bot_col}"
        top_val = top_col.to_i(2)
        bot_val = bot_col.to_i(2)
        putss "col #{col}: #{top_val} <-> #{bot_val}"
        diff = top_val ^ bot_val
        smudge = has_smudge diff

        if top_val == bot_val or smudge
          i = col-1
          j = col+2
          putss "We have a match or a possible smudge ... iterate #{i}, #{j}"
          same = true

          loop do 
            top_col = puzzle[i]
            bot_col = puzzle[j]
            putss "  Icol #{i}&#{j}: #{top_col} <-> #{bot_col}"
            top_val = top_col.to_i(2)
            bot_val = bot_col.to_i(2)
            putss "  Icol #{i}&#{j}: #{top_val} <-> #{bot_val}"
            diff = top_val ^ bot_val
            inner_smudge = has_smudge diff

            # if there was already a smudge
            # putss "   smudge and inner smudge #{smudge} and #{inner_smudge}"
            if smudge and inner_smudge
              putss "  We already saw a smudge, and now we see another".red
              putss "  so we have to say they are not the same".red
              same = false
            elsif inner_smudge
              putss "  We have not seen a smudge yet, so this is the first".green
              putss "  setting to true".green
              smudge = true if inner_smudge
            end

            break unless same
            i -= 1
            j += 1
            break if i < 0 or j >= puzzle.length
          end unless i < 0 or j >= puzzle.length
        end

        if same and smudge
          putss "Found same and had a smudge. Yay!".green
          cols += col+1
          break
        end
      end
    end

    putss
    putss "Ending with #{rows} and #{cols}".green
    throw "TOO MANY" if rows > 0 and cols > 0
    throw "TOO FEW" if rows == 0 and cols == 0

    score = cols + (rows * 100)
    throw "SCORE OF ZERO IS BAD" if score == 0

    putss "...which is a score of #{score}".green
    score
  end

  def self.lee(puzzle)
    rows, cols = [0,0] # start with a blank count

    putss
    putss "Lee Solve puzzle"
    puzzle.each { |x| ps x }
    putss
    xor_puzzle = puzzle.map { |x| x.to_i(2) }
    xor_puzzle.each { |x| ps x }
    putss

    (0..xor_puzzle.length-2).each do |row|
      putss "Row #{row}: #{xor_puzzle[row]} <-> #{xor_puzzle[row+1]}"
      xor = xor_puzzle[row] ^ xor_puzzle[row+1]
      putss "  with xor #{xor}"
      if xor==0 or (xor & (xor-1) == 0)
        smudge = xor != 0
        putss "  Is a match of some kind: smudge is -> #{smudge}"
        
        steps = 1
        loop do
          break if row-steps < 0 or row+steps+1 >= xor_puzzle.length 
          if xor_puzzle[row-steps] != xor_puzzle[row+steps+1]
            putss "  Looking at #{xor_puzzle[row-steps]} <--> #{xor_puzzle[row+steps+1]}"
            xor2 = xor_puzzle[row-steps] ^ xor_puzzle[row+steps+1]
            if (xor2 & (xor2 - 1) == 0) and !smudge
              putss "    is a smudge".green
              smudge = true
            else
              putss "    is not a smudge".red
              smudge = false
              break
            end
          else
            putss "  Same for at #{xor_puzzle[row-steps]} <--> #{xor_puzzle[row+steps+1]}"
          end
          steps += 1
        end
      end
      return (row+1) * 100 if smudge
    end

    putss "We found no rows, so we should transpose and try columns".red
    puzzle = puzzle.map{|r| r.chars}.transpose
    puzzle.map!{|r| r.join}

    putss
    putss "Lee Solve cols puzzle"
    puzzle.each { |x| ps x }
    putss
    xor_puzzle = puzzle.map! { |x| x.to_i(2) }
    xor_puzzle.each { |x| ps x }
    putss

    (0..xor_puzzle.length-2).each do |row|
      putss "Row #{row}: #{xor_puzzle[row]} <-> #{xor_puzzle[row+1]}"
      xor = xor_puzzle[row] ^ xor_puzzle[row+1]
      putss "  with xor #{xor}"
      if xor==0 or (xor & (xor-1) == 0)
        smudge = xor != 0
        putss "  Is a match of some kind: smudge is -> #{smudge}"
        
        steps = 1
        loop do
          break if row-steps < 0 or row+steps+1 >= xor_puzzle.length 
          if xor_puzzle[row-steps] != xor_puzzle[row+steps+1]
            putss "  Looking at #{xor_puzzle[row-steps]} <--> #{xor_puzzle[row+steps+1]}"
            xor2 = xor_puzzle[row-steps] ^ xor_puzzle[row+steps+1]
            if (xor2 & (xor2 - 1) == 0) and !smudge
              putss "    is a smudge".green
              smudge = true
            else
              putss "    is not a smudge".red
              smudge = false
              break
            end
          else
            putss "  Same for at #{xor_puzzle[row-steps]} <--> #{xor_puzzle[row+steps+1]}"
          end
          steps += 1
        end
      end
      return (row+1) if smudge
    end

    throw "shouldn't get here"
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

  def self.gold(input)
    sum = 0
    puzzle = []
    input.each do |line|
      if line == ''
        sum += lee puzzle
        puzzle = []
      else
        puzzle << line.gsub('.','0').gsub('#','1')
      end
    end
    sum+= lee puzzle

    sum
  end
end
