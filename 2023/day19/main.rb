require_relative '../../helpers'
require 'io/console'
require 'set'
require 'progress_bar'

class Condition
  attr_reader :outcome, :value, :op, :compare

  def initialize(cond)
    @value, @op, @compare, @outcome = cond.scan(/(.)(.)(\d+):(\w+)/).flatten
    @compare = @compare.to_i
  end

  def check_part(part)
    # puts "    Running Condition for #{@value} #{@op} #{@compare} with #{part.instance_variable_get('@'+@value)}"
    case @op
    when '<'
      part.instance_variable_get('@'+@value) < @compare
    when '>'
      part.instance_variable_get('@'+@value) > @compare
    end
  end
end

class Workflow
  attr_reader :name, :conditions, :last_resort

  def initialize(name, conditions, last_resort)
    @name = name
    @conditions = conditions.map {|c| Condition.new c}
    @last_resort = last_resort
  end

  def rule(piece)
    pass = @conditions.find {|c| c.check_part piece}
    pass.nil? ? @last_resort : pass.outcome
  end
end

class Part
  attr_reader :x,:m,:a,:s

  def initialize(values)
    @x, @m, @a, @s = values.map(&:to_i)
  end

  def sum
    @x+@m+@a+@s
  end
end

class AOC
  def self.parse(lines)
    rules = {}
    parts = []
    parse_as_rule = true
    lines.each do |line|
      if line == ''
        parse_as_rule = false
      elsif parse_as_rule
        label, conditions = line.scan(/(\w+)\{(.+)\}/).flatten
        # p label
        conditions = conditions.split(',')
        # p conditions
        last_resort = conditions.pop
        # p last_resort
        # p conditions
        rules[label] = Workflow.new(label, conditions, last_resort)
      else
        values = line.scan(/(\d+)+/).flatten
        parts << Part.new(values)
      end
    end

    [rules, parts]
  end

  def self.silver(lines)
    rules, parts = parse lines
    rules.each {|r| p r }
    parts.each {|r| p r }

    selected = parts.select do |part|
      workflow = rules['in']
      loop do
        # puts "Checking part with x #{part.x} with rule #{workflow.name}"
        next_up = workflow.rule part
        # puts " and got #{next_up}"
        if next_up == 'A'
          # puts "Accept part"
          break true
        elsif next_up =='R'
          # puts "Reject part"
          break false
        end
        break if next_up == 'A' or next_up == 'R'
        workflow = rules[next_up]
      end
    end
    selected.each {|s| p s}
    selected.map(&:sum).inject(:+)
  end

  def self.get_count_from_set(set)
    x = set[:x].last - set[:x].first
    m = set[:m].last - set[:m].first
    a = set[:a].last - set[:a].first
    s = set[:s].last - set[:s].first

    val = x*m*a*s
    # puts "Value for #{set} is #{val}".green
    val
  end
  def self.gold(lines)
    # num = 4000*4000*4000*4000
    # progress_bar = ProgressBar.new(num)
    rules, parts = parse lines

    count = 0
    ranges = []
    stack = [{workflow: 'in', data_set: {'x':1..4001, 'm': 1..4001, 'a': 1..4001, 's': 1..4001}}]
    loop do
      puts "in loop"
      current = stack.pop
      remainder = current[:data_set]
      puts "working on #{current}"
      workflow = rules[current[:workflow]]
      workflow.conditions.each do |c|
        puts "Conditon operates on #{c.value} #{c.op} #{c.compare}"
        case c.value
        when 'x'
          set1, set2 = [remainder.clone, remainder.clone]
          set1.delete(:x)
          set2.delete(:x)
          if c.op == '<'
            set1[:x] = remainder[:x].min..c.compare
            set2[:x] = c.compare..remainder[:x].max
            p set1, set2
            if c.outcome == 'R'
              # do nothing
              puts "Rejecting".red
              p set1
            elsif c.outcome == 'A'
              puts "Accepting.".green
              p set1
              ranges << set1
              count += get_count_from_set(set1)
              puts "count is now #{count}".green
            else
              puts "Pushing #{{workflow: c.outcome, data_set:set1}}"
              stack.push({workflow:c.outcome, data_set:set1})
            end
            remainder = set2
          else
            set1[:x] = remainder[:x].min..c.compare+1
            set2[:x] = c.compare+1..remainder[:x].max
            p set1, set2
            if c.outcome == 'R'
              # do nothing
              puts "Rejecting".red
              p set2
            elsif c.outcome == 'A'
              puts "Accepting.".green
              p set2
              ranges << set2
              count += get_count_from_set(set2)
              puts "count is now #{count}".green
            else
              puts "Pushing #{{workflow: c.outcome, data_set:set2}}"
              stack.push({workflow:c.outcome, data_set:set2})
            end
            remainder = set1
          end
        when 'm'
          set1, set2 = [remainder.clone, remainder.clone]
          set1.delete(:m)
          set2.delete(:m)
          if c.op == '<'
            set1[:m] = remainder[:m].min..c.compare
            set2[:m] = c.compare..remainder[:m].max
            p set1, set2
            if c.outcome == 'R'
              # do nothing
              puts "Rejecting".red
              p set1
            elsif c.outcome == 'A'
              puts "Accepting.".green
              p set1
              ranges << set1
              count += get_count_from_set(set1)
              puts "count is now #{count}".green
            else
              puts "Pushing #{{workflow: c.outcome, data_set:set1}}"
              stack.push({workflow:c.outcome, data_set:set1})
            end
            remainder = set2
          else
            set1[:m] = remainder[:m].min..c.compare+1
            set2[:m] = c.compare+1..remainder[:m].max
            p set1, set2
            if c.outcome == 'R'
              # do nothing
              puts "Rejecting".red
              p set2
            elsif c.outcome == 'A'
              puts "Accepting.".green
              p set2
              ranges << set2
              count += get_count_from_set(set2)
              puts "count is now #{count}".green
            else
              puts "Pushing #{{workflow: c.outcome, data_set:set2}}"
              stack.push({workflow:c.outcome, data_set:set2})
            end
            remainder = set1
          end
        when 'a'
          set1, set2 = [remainder.clone, remainder.clone]
          set1.delete(:a)
          set2.delete(:a)
          if c.op == '<'
            set1[:a] = remainder[:a].min..c.compare
            set2[:a] = c.compare..remainder[:a].max
            p set1, set2
            if c.outcome == 'R'
              # do nothing
              puts "Rejecting".red
              p set1
            elsif c.outcome == 'A'
              puts "Accepting.".green
              p set1
              ranges << set1
              count += get_count_from_set(set1)
              puts "count is now #{count}".green
            else
              puts "Pushing #{{workflow: c.outcome, data_set:set1}}"
              stack.push({workflow:c.outcome, data_set:set1})
            end
            remainder = set2
          else
            set1[:a] = remainder[:a].min..c.compare+1
            set2[:a] = c.compare+1..remainder[:a].max
            p set1, set2
            if c.outcome == 'R'
              # do nothing
              puts "Rejecting".red
              p set2
            elsif c.outcome == 'A'
              puts "Accepting.".green
              p set2
              ranges << set2
              count += get_count_from_set(set2)
              puts "count is now #{count}".green
            else
              puts "Pushing #{{workflow: c.outcome, data_set:set2}}"
              stack.push({workflow:c.outcome, data_set:set2})
            end
            remainder = set1
          end
        when 's'
          set1, set2 = [remainder.clone, remainder.clone]
          set1.delete(:s)
          set2.delete(:s)
          if c.op == '<'
            set1[:s] = remainder[:s].min..c.compare
            set2[:s] = c.compare..remainder[:s].max
            p set1, set2
            if c.outcome == 'R'
              # do nothing
              puts "Rejecting".red
              p set1
            elsif c.outcome == 'A'
              puts "Accepting.".green
              p set1
              ranges << set1
              count += get_count_from_set(set1)
              puts "count is now #{count}".green
            else
              puts "Pushing #{{workflow: c.outcome, data_set:set1}}"
              stack.push({workflow:c.outcome, data_set:set1})
            end
            remainder = set2
          else
            set1[:s] = remainder[:s].min..c.compare+1
            set2[:s] = c.compare+1..remainder[:s].max
            p set1, set2
            if c.outcome == 'R'
              # do nothing
              puts "Rejecting".red
              p set2
            elsif c.outcome == 'A'
              puts "Accepting.".green
              p set2
              ranges << set2
              count += get_count_from_set(set2)
              puts "count is now #{count}".green
            else
              puts "Pushing #{{workflow: c.outcome, data_set:set2}}"
              stack.push({workflow:c.outcome, data_set:set2})
            end
            remainder = set1
          end
        end
      end
      puts "deal with remainder"
      if workflow.last_resort == 'R'
        # do nothing
        puts "Rejecting".red
        p remainder
      elsif workflow.last_resort == 'A'
        puts "Accepting.".green
        p remainder
        ranges << remainder
        count += get_count_from_set(remainder)
        puts "count is now #{count}".green
      else
        puts "Pushing #{{workflow: workflow.last_resort, data_set:remainder}}"
        stack.push({workflow:workflow.last_resort, data_set:remainder})
      end

      break if stack.length < 1
      puts
      puts "Stack is now"
      # p stack
      stack.each {|s| p s}
      puts
    end
    ranges.each{|r| puts "X: #{r[:x]} \t M: #{r[:m]} \t A: #{r[:a]} \t S: #{r[:s]}"}
    puts
    ranges.each{|r| puts "X: #{r[:x].last - r[:x].first} \t M: #{r[:m].last - r[:m].first} \t A: #{r[:a].last - r[:a].first} \t S: #{r[:s].last - r[:s].first} \t Which is #{get_count_from_set(r)}"}
    count
  end
end
