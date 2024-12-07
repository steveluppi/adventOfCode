require_relative '../../helpers'
require 'io/console'
require 'set'

class AOC
  def self.parse_input lines
    $rules = []
    $page_lines = []

    loop do
      l = lines.shift
      break if l.empty?

      $rules << l.split('|')
    end
    # p $rules

    loop do
      break if lines.empty?
      l = lines.shift
      $page_lines << l
    end
    # p $page_lines
  end

  def self.safe_vs_unsafe_lines lines
    AOC.parse_input lines

    $safe_lines = []
    $unsafe_lines = []

    $page_lines.each do |line|
      # puts "working on line #{line}".red
      seen = []
      safe = true
      line.split(',').each do |page|
        # puts "eval page #{page}"
        # puts "against seen #{seen}"
        comes_before = $rules.select {|r| r[0]==page}.map {|r|  r[1]}
        # puts "has to come before #{comes_before}"
        # puts "   which has overlap with seen as #{comes_before&seen}"
        if !(comes_before & seen).empty?
          # puts "unsafe"
          safe = false
          break
        end
        seen << page
      end
      # puts "line #{line} is unsafe".red unless safe
      # puts "line #{line} is safe".green if safe
      $safe_lines << line if safe
      $unsafe_lines << line unless safe
    end

  end

  def self.silver(lines)
    AOC.safe_vs_unsafe_lines lines

    $safe_lines.map {|line| l=line.split(','); l[l.length/2].to_i}.sum
  end

  def self.gold(lines)
    AOC.safe_vs_unsafe_lines lines

    $unsafe_lines.map! do |line|
      puts "HAVE TO REORDER LINE #{line}".green
      # need to sort them
      new_line =[]
      line.split(',').each do |page|
        puts "looking at page #{page}"
        comes_before = $rules.select {|r| r[0]==page}.map{|r| r[1]}
        # easy one ... if it's empty just add it
        if new_line.empty?
          new_line << page 
          puts "new line was empty, just add #{page}"
        elsif comes_before.empty?
          puts "#{page} has no rules, put it at the end"
          new_line.push page
        elsif (comes_before & new_line).empty?
          puts "Newline has no overlap with rules, put it at the end"
          new_line.push page
        else
          # now we need to place it in the right spot
          puts "line is #{new_line}, so #{page} has to come before #{comes_before}"
          for idx in 0..new_line.length-1 do
            puts "new_line already has #{new_line[idx]} at index #{idx}" 
            if comes_before.include? new_line[idx]
              puts "#{page} has to come before #{new_line[idx]}"
              new_line.insert(idx, page)
              break;
            end
          end
        end
      end
      puts "#{line} is now #{new_line}".green
      new_line
    end

    $unsafe_lines.map {|l| l[l.length/2].to_i}.sum
  end
end
