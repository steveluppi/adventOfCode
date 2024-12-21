require_relative '../../helpers'
require 'io/console'
require 'set'

$debug = true
class Handheld
  def initialize(a,b,c,prog)
    @a = a
    @b = b
    @c = c
    @ip = 0
    @p = prog
    @halted = false
    @output = []
  end

  def output
    @output.join(',')
  end

  def halted?
    @halted
  end

  def operate
    opcode, operand = @p.slice(@ip, 2)
    combo = nil
    debug "Opcode: #{opcode} Operand: #{operand}"

    if operand <= 3
      combo = operand
    elsif operand == 4
      combo = @a
    elsif operand == 5
      combo = @b
    elsif operand == 6
      combo = @c
    end

    case opcode
    when 0
      debug "adv - Division of A by 2^#{combo}".green
      # debug "2^#{combo} is #{2**combo}"
      val = @a / (2**combo)
      # debg "makes value #{val}"
      @a = val
    when 1
      debug "bxl - bitwise XOR of B and literal operand".green
      val = @b ^ operand
      @b = val
    when 2
      debug "bst combo #{combo} % 8".green
      val = combo % 8
      @b = val
    when 3
      debug "jnz".green
      if @a == 0
        debug "A Reg is zero, so do nothing"
      else
        debug "A is not zero....so jump to #{operand}"
        @ip = operand
        @halted = true if @ip >= @p.length
        return
      end
    when 4
      debug "bxc - bitwise XOR of $B and $C".green
      val = @b ^ @c
      @b = val
    when 5
      debug "out - output combo #{combo} % 8".green
      val = combo % 8
      @output << val
    when 6
      debug "bdv - Division of a by 2^#{combo} -> B".green
      val = @a / (2**combo)
      @b = val
    when 7
      debug "cdv - Division of a by 2^#{combo} -> C".green
      val = @a / (2**combo)
      @c = val
    end

    @ip += 2
    @halted = true if @ip >= @p.length
  end

  def to_s
    "Handheld:\n A: #{@a}\n B: #{@b}\n C: #{@c}\n IP: #{@ip}\n Output: #{@output.join(',')}"
  end
end

class AOC
  def self.silver(lines)
    $A = 729
    $B = 0
    $C = 0
    program = [0,1,5,4,3,0]
    ip = 0
    output = []

    # Silver
    $A = 22817223
    $B = 0
    $C = 0
    program = [2,4,1,2,7,5,4,5,0,3,1,7,5,5,3,0]
    ip = 0

    loop do
      break if ip >= program.length

      opcode, operand = program.slice(ip, 2)
      combo = nil
      debug "Opcode: #{opcode} Operand: #{operand}"

      if operand <= 3# or operand == 7
        combo = operand
      elsif operand == 4
        combo = $A
      elsif operand == 5
        combo = $B
      elsif operand == 6
        combo = $C
      end

      throw "combo is nil" if combo.nil?

      case opcode
      when 0
        debug "adv - Division of A by 2^#{combo}".green
        # debug "2^#{combo} is #{2**combo}"
        val = $A / (2**combo)
        # debg "makes value #{val}"
        $A = val
      when 1
        debug "bxl - bitwise XOR of B and literal operand".green
        val = $B ^ operand
        $B = val
      when 2
        debug "bst combo #{combo} % 8".green
        val = combo % 8
        $B = val
      when 3
        debug "jnz".green
        if $A == 0
          debug "A Reg is zero, so do nothing"
        else
          debug "A is not zero....so jump to #{operand}"
          ip = operand
          next
        end
      when 4
        debug "bxc - bitwise XOR of $B and $C".green
        val = $B ^ $C
        $B = val
      when 5
        debug "out - output combo #{combo} % 8".green
        val = combo % 8
        output << val
      when 6
        debug "bdv - Division of a by 2^#{combo} -> B".green
        val = $A / (2**combo)
        $B = val
      when 7
        debug "cdv - Division of a by 2^#{combo} -> C".green
        val = $A / (2**combo)
        $C = val
      end

      debug "Registers are now:"
      debug " A: #{$A}"
      debug " B: #{$B}"
      debug " C: #{$C}"
      debug " ip: #{ip}"
      debug " output: #{output}"
      ip+=2
    end
    puts "DONE".green
    puts output.join(',')
  rescue StandardError => e
    puts e.message
    puts "!!! *** !!! WTF".red
    exit
  end

  def self.gold(lines)
    # hh = Handheld.new(729,0,0,[0,1,5,4,3,0])
    # hh = Handheld.new(22817223, 0, 0, [2,4,1,2,7,5,4,5,0,3,1,7,5,5,3,0])

    iterator = 1
    target_program = [2,4,1,2,7,5,4,5,0,3,1,7,5,5,3,0].join(',')
    loop do 
      puts
      puts "Creating new Handheld for #{iterator}".red

      hh = Handheld.new(iterator, 0, 0, [2,4,1,2,7,5,4,5,0,3,1,7,5,5,3,0])

      loop do
        break if hh.halted?
        break unless target_program.index(hh.output) == 0
        hh.operate
        puts hh
      end

      puts "HH broke - check if end".red
      puts hh.output
      puts target_program
      break if hh.output == target_program
      iterator += 1
      # throw "too far" if iterator > 117440
    end

    puts "Worked on #{iterator}"

    iterator
  end
end
