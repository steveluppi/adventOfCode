require_relative '../../helpers'
require 'ruby-progressbar'
require 'io/console'
require 'set'

DEBUG = false

class AOC
  def self.gold(line)
    # puzzle, pattern = '.??..??...?##. 1,1,3'.split(' ')
    # puzzle, pattern = '????.######..#####. 1,6,5'.split(' ')
    puzzle, pattern = line.split(' ')
    # s_puzzle, s_pattern = line.split(' ')

    big_pattern = []
    5.times { big_pattern << pattern }
    big_pattern = big_pattern.join(',')
    
    # puzzle, pattern = [[],[]]
    # big_pattern = []

    # 5.times do
    #   puzzle << s_puzzle
    #   pattern << s_pattern
    # end
    # puzzle = puzzle.join('?')
    # pattern = pattern.join(',')
    # puts "big puzzle #{[puzzle,puzzle,puzzle,puzzle,puzzle].join('?')}"
    # puts "           ???.###????.###????.###????.###????.###"
    pattern = pattern.split(',').map(&:to_i)
    big_pattern = big_pattern.split(',').map(&:to_i)
    puts "Finding arrangement for #{puzzle} with pattern #{pattern}"
    puts "  which is #{big_pattern}"
    stack = ['']

    pos = 0
    
    puts
    puts "Finding Possiblities"
    loop do 
      at = puzzle[pos]
      puts "looking at pos #{pos} which is #{at}" if DEBUG
      puts "with stack" if DEBUG
      p stack if DEBUG
      pos += 1

      case at
      when '.'
        stack.map! { |e| e+'.' }
      when '#'
        stack.map! { |e| e+'#' }
      when '?'
        clone = stack.clone
        stack.map! { |e| e+'.' }
        clone.map! { |e| e+'#' }
        stack << clone
        stack.flatten!
      end

      break if (pos >= puzzle.length)
    end   
    p stack if DEBUG

    puts "Finding bigger possibilities"
    bigger_stack = []
    stack.each do |g|
      ministack = [g.clone]
      4.times do
        clone = ministack.clone
        ministack.map! { |e| e+'.'+g.clone }
        clone.map! { |e| e+'#'+g.clone }
        ministack << clone
        ministack.flatten!
        # ministack.each { |m| p m }
        # q_to_quit
      end
      bigger_stack << ministack
      bigger_stack.flatten!
    end
      puts
      # bigger_stack.each { |m| p m }
      p stack.length
      p bigger_stack.length
      # q_to_quit
      
    if true
      puts "Finding which ones match the bigger pattern"
      count = 0
      bigger_stack.each do |g|  
        puts "working on #{g}" if DEBUG
        s = g.scan /\.?(\#+)\.?/ 
        p s if DEBUG
        c = s.flatten.map { |m| m.length }
        p c  if DEBUG
        puts "match on #{g} with #{c}" if c == big_pattern if DEBUG
        count += 1 if c == big_pattern
      end
    else
      puts "Finding which ones match the pattern"
      count = 0
      stack.each do |g|  
        puts "working on #{g}" if DEBUG
        s = g.scan /x?(\#+)x?/ 
        p s if DEBUG
        c = s.flatten.map { |m| m.length }
        p c  if DEBUG
        puts "match on #{g} with #{c}" if c == pattern if DEBUG
        count += 1 if c == pattern
      end
    end
    puts "Found #{count} matches"
    count
  end

  def self.silver(line)
    # puzzle, pattern = '.??..??...?##. 1,1,3'.split(' ')
    # puzzle, pattern = '????.######..#####. 1,6,5'.split(' ')
    puzzle, pattern = line.split(' ')

    pattern = pattern.split(',').map(&:to_i)
    puts "Finding arrangement for #{puzzle} with pattern #{pattern}"
    stack = []

    pos = 0
    # stack = [puzzle[0]=='.' ? 'x' : puzzle[0]]
    stack = ['']
    loop do 
      at = puzzle[pos]
      puts "looking at pos #{pos} which is #{at}" if DEBUG
      puts "with stack" if DEBUG
      p stack if DEBUG
      pos += 1

      case at
      when '.'
        stack.map! { |e| e+'x' }
      when '#'
        stack.map! { |e| e+'#' }
      when '?'
        clone = stack.clone
        stack.map! { |e| e+'x' }
        clone.map! { |e| e+'#' }
        stack << clone
        stack.flatten!
      end

      break if (pos >= puzzle.length)
    end   
    p stack if DEBUG
    count = 0
    stack.each do |g|  
      puts "working on #{g}" if DEBUG
      s = g.scan /x?(\#+)x?/ 
      p s if DEBUG
      c = s.flatten.map { |m| m.length }
      p c  if DEBUG
      puts "match on #{g} with #{c}" if c == pattern if DEBUG
      count += 1 if c == pattern
    end
    count
  end
  def self.q_to_quit
    x=$stdin.getch
    exit if x == 'q'
  end
end
