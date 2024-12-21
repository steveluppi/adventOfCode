require_relative '../../helpers'
require 'io/console'
require 'set'

class AOC
  def self.do_math entry
    product = entry.first
    nums = entry.last
    puts "processing #{product} from #{nums}"

    if nums.length == 1
      puts "nums length = 1, so let's go"
      puts " so we compare #{product} to #{nums}"
      continue
      return product == nums.first ? product : nil
    end

    puts "nums length was greater than 1"
    op1 = nums.shift
    op2 = nums.shift

    puts "  which gives us #{op1} and #{op2}"
    continue

    res1 = AOC.do_math [product, nums.clone.unshift(op1+op2)]
    puts "  res 1 is #{res1} against #{product}"
    continue
    return product if res1 == product
    return nil if !res1.nil? and res1 > product

    res2 = AOC.do_math [product, nums.clone.unshift(op1*op2)]
    puts "  res 2 is #{res2} against #{product}"
    continue
    return product if res2 == product
    return nil if !res2.nil? and res2 > product

    nil
  end

  def self.silver(lines)
    lines.map! do |l|
      first = l.split ':'
      product = first.first.to_i
      nums = first.last.split(' ').map(&:to_i)

      [product, nums]
    end

    $sum = 0
    lines.map! do |line|
      q = [line]
      match = false
      loop do
        break if q.empty?
        work = q.shift
        puts "working on #{work}"
        if work.last.length == 1
          # there is only one numbrer...compare
          puts "there is only one number, so we compare #{work.first} and #{work.last.first}"
          puts "and we add it".green if work.first == work.last.first
          match = true if work.first == work.last.first
        else
          # we need to do more work and add back to tbe queue?
          nums = work.last
          op1 = nums.shift
          op2 = nums.shift
          puts "there is more than one number, so we deal with #{op1} and #{op2}"
          next if op1 > work.first

          q << [work.first, nums.clone.unshift(op1+op2)]
          q << [work.first, nums.clone.unshift(op1*op2)]
        end
      end
      $sum += line.first if match
    end

    $sum
  end

  def self.gold1(lines)
    lines.map! do |l|
      first = l.split ':'
      product = first.first.to_i
      nums = first.last.split(' ').map(&:to_i)

      [product, nums]
    end

    $sum = 0
    lines.map! do |line|
      q = [line]
      match = false
      loop do
        break if q.empty?
        work = q.shift
        puts "working on #{work}"
        if work.last.length == 1
          # there is only one numbrer...compare
          puts "there is only one number, so we compare #{work.first} and #{work.last.first}"
          puts "and we add it".green if work.first == work.last.first
          match = true if work.first == work.last.first
        else
          # we need to do more work and add back to tbe queue?
          nums = work.last
          op1 = nums.shift
          op2 = nums.shift
          puts "there is more than one number, so we deal with #{op1} and #{op2}"

          q << [work.first, nums.clone.unshift(op1+op2)]
          q << [work.first, nums.clone.unshift(op1*op2)]
          q << [work.first, nums.clone.unshift("#{op1}#{op2}".to_i)]
        end
      end
      $sum += line.first if match
    end

    $sum
  end
  def self.gold(lines)
    $sum=0
    lines.map! do |l|
      first = l.split ':'
      product = first.first.to_i
      nums = first.last.split(' ').map(&:to_i)

      [product, nums]
    end
    lines.each do |line|
      product = line.first
      numbers = line.last
      
      spaces = numbers.length-1
      combos = 3**spaces
      
      puts "#{line} has #{spaces} spaces and #{combos} combos"
      for c in 0..combos-1 do
        res = 0
        combo = c.to_s(3)
        loop do
          break if combo.length >= spaces
          combo = "0#{combo}"
        end
        puts "combo #{c}: #{combo}"
        for s in 0..spaces-1 do
          bit = combo[s].to_i
          puts "working on bit #{s} from #{combo} which is #{bit}"
          left = s==0 ? numbers.first : res
          if bit == 0
            res = left + numbers[s+1]
          elsif bit == 1
            res = left * numbers[s+1]
          else
            res = "#{left}#{numbers[s+1]}".to_i
          end
        end
        puts "result is #{res}"
        if res == product
          puts "  which is a match".green
          $sum += product
          break
        end
      end
    end
    p $sum
    $sum
  end
end
# p AOC.silver(read_file_and_chomp('example.txt'))
