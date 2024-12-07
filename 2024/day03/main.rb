require_relative '../../helpers'
require 'io/console'
require 'set'

class AOC
  def self.silver(lines)
    lines.map! do |l|
      mul_ops = l.scan(/mul\(\d{1,3},\d{1,3}\)/)
      mul_ops.map! do |op|
        nums = op.scan(/\d+/).map(&:to_i)
        nums.reduce(:*)
      end
    end
    lines.map {|l| l.sum}.sum
  end

  def self.gold(lines)
    enabled = true
    lines.map! do |l|
      ops = l.scan(/mul\(\d{1,3},\d{1,3}\)|do\(\)|don\'t\(\)/)
      p ops
      ops.map! do |op|
        if op.include? 'do('
          enabled=true
          next 0
        elsif op.include? 'don'
          enabled=false
          next 0
        else
          next 0 unless enabled
          nums = op.scan(/\d+/).map(&:to_i)
          nums.reduce(:*)
        end
      end
    end
    p lines
    lines.map {|l| l.sum}.sum
  end

  def self.do_mul_op input
    mul_ops = input.scan(/mul\(\d{1,3},\d{1,3}\)/)
    mul_ops.map! do |op|
      nums = op.scan(/\d+/).map(&:to_i)
      nums.reduce(:*)
    end
    mul_ops.sum
  end

  def self.gold2(lines)
    enabled = true

    lines.map! do |l|
      sum=0

      scan_do = StringScanner.new(l)
      scan_dont = StringScanner.new(l)

      loop do
        puts "start scan with length #{scan_do.rest.size}"

        scan_do.scan_until /do\(\)/
        scan_dont.scan_until /don\'t\(\)/

        if scan_do.pos < scan_dont.pos
          sum += AOC.do_mul_op scan_do.pre_match if enabled
          scan_do = StringScanner.new(scan_do.rest)
          scan_dont = StringScanner.new(scan_do.rest)
          enabled = true
        else
          sum += AOC.do_mul_op scan_dont.pre_match if enabled
          scan_do = StringScanner.new(scan_dont.rest)
          scan_dont = StringScanner.new(scan_dont.rest)
          enabled = false
        end
      end

      sum
    end

    puts "lines after iteration #{lines}"
    lines.sum
  end

  def self.gold_first(lines)
    enabled = true
    lines.map! do |l|
      breaker = false
      sum=0

      s = StringScanner.new(l)

      loop do
        if enabled
          s.scan_until(/don\'t\(/)
          puts "matched"
          p s.matched
          p s.pos
          puts "matched"
          p s.pre_match
          the_match = s.pre_match unless s.pre_match.nil?
          if s.pre_match.nil?
            the_match = s.reset.rest
            puts "setting breaker"
            breaker=true
          end

          mul_ops = the_match.scan(/mul\(\d{1,3},\d{1,3}\)/)
          mul_ops.map! do |op|
            nums = op.scan(/\d+/).map(&:to_i)
            nums.reduce(:*)
          end
          sum += mul_ops.sum
          puts "sum is now #{sum}"
          enabled=false
          s = StringScanner.new(s.rest)
          break if breaker
          next
        else
          p s
          s.scan_until(/do\(/)
          p s.pre_match
          enabled=true
          s = StringScanner.new(s.rest)
          p s
          next
        end
        break if s.nil?
        break if s.eos?
      end
      sum
    end
    p lines
    lines.sum
  end
end
