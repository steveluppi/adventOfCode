require_relative '../../helpers'
require 'io/console'
require 'set'

class AOC
  def self.silver(lines)
    reports = lines.map { |l| l.split(' ').map(&:to_i) }
    reports.map! { |r| AOC.is_report_safe? r }
    reports.reject {|r| r==false}.size
  end

  def self.gold(lines)
    reports = lines.map { |l| l.split(' ').map(&:to_i) }

    pineapple = 0 # got to have a safe word

    reports.each do |r| 
      res = AOC.is_report_safe_gold? r 
      puts "The inital result from report #{r} is #{res}"
      unless res.is_a? Numeric
        pineapple = pineapple + 1
        next
      end

      puts "  which would remove #{r[res]}" if res.is_a? Numeric
      puts "  or #{r[res-1]}" if res.is_a? Numeric
      a = r.map(&:clone)
      b = r.map(&:clone)
      a.delete_at res-1
      b.delete_at res
      
      puts "making them #{a} and #{b}"

      res_a = AOC.is_report_safe_gold? a
      res_b = AOC.is_report_safe_gold? b
      puts "which gets us results #{res_a} and #{res_b}"
      puts "return true" if (res_a == true or res_b == true)
      # continue
      if (res_a == true or res_b == true)
        pineapple = pineapple + 1
        next
      end

      File.write('bad.txt', "#{r}\n", mode: 'a+') unless (res_a == true or res_b == true)

      c = r.map(&:clone)
      c.shift
      res_c = AOC.is_report_safe_gold? c
      if res_c == true
        pineapple = pineapple + 1
        next
      end
    end

    pineapple
  end

  def self.is_report_safe_gold? report
    direction = report[0] > report[1] ? 'decreasing' : 'increasing'
    safe = true
    report.each_with_index do |entry, idx|
      next if idx==0
      puts "working on #{entry} at #{idx} against #{report[idx-1]}"
      if direction == 'decreasing'
        diff = report[idx-1] - entry
        p diff
        return idx if diff <= 0
        return idx if diff > 3
      else
        diff = entry - report[idx-1]
        p diff
        return idx if diff <= 0
        return idx if diff > 3
      end
    end
    p safe
  end

  def self.is_report_safe? report
    p report
    direction = report[0] > report[1] ? 'decreasing' : 'increasing'
    p direction
    safe = true
    report.each_with_index do |entry, idx|
      next if idx==0
      puts "working on #{entry} at #{idx} against #{report[idx-1]}"
      if direction == 'decreasing'
        diff = report[idx-1] - entry
        p diff
        safe = false if diff <= 0
        safe = false if diff > 3
      else
        diff = entry - report[idx-1]
        p diff
        safe = false if diff <= 0
        safe = false if diff > 3
      end
    end
    p safe
  end
end


#count=AOC.gold(read_file_and_chomp('silver.txt'))
#puts "Final count is #{count}"
