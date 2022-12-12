# Advent of Code - Day 11
require_relative "../helpers"

class Monkey
  attr_reader :id
  attr_reader :inspection_count
  attr_accessor :items
  attr_accessor :worry_op
  attr_accessor :worry_op_left
  attr_accessor :worry_op_right
  attr_accessor :test_factor
  attr_accessor :true_target
  attr_accessor :false_target

  @id=nil
  @items=[]
  @worry_op=nil
  @worry_op_left=nil
  @worry_op_right=nil
  @test_factor=nil
  @true_target=nil
  @false_target=nil
  @inspection_count=0

  # def initialize(id, items, op, factor, true_target, false_target)
  #   @id = id
  #   @items = items
  #   @worry_op = op
  #   @worry_op_factor = factor
  #   @true_target = true_target
  #   @false_target = false_target
  # end

  def initialize(id)
    @id=id
  end

  def to_s
    puts "Monkey #{@id}:"
    puts "  Starting Items:#{@items}" unless @items.nil?
    puts "  Operation: #{@worry_op_left} #{@worry_op} #{worry_op_right}" unless @worry_op.nil? or @worry_op_left.nil? or @worry_op_right.nil?
    puts "  Test: divisible by #{@test_factor}" unless @test_factor.nil?
    puts "    If true: throw to monkey #{@true_target}" unless @true_target.nil?
    puts "    If false: throw to monkey #{@false_target}" unless @false_target.nil?
  end

  def inspect
    @inspection_count = @inspection_count.to_i + 1
  end

  def playTurn
  end

  def catchItem
  end
end

def parseMonkey(lines)
  current_id=nil
  monkeys = []
  for l in lines
    case l
      when /^$/
        next
      when /^Monkey \d+:/
        m = /^Monkey (\d+):/.match(l)[1]
        # puts "Monkey id #{m}"
        current_id=m.to_i
        monkeys.push(Monkey.new(current_id))
      when /Starting items:/
        m = /Starting items: ((\d+,? ?)+)/.match(l)[1].split(', ')
        (monkeys.find{|m| m.id==current_id}).items = m
        # p m
      when /Operation:/
        m = /Operation: new = ([old|\d]+) (.) ([old|\d]+)$/.match(l)
        (monkeys.find{|m| m.id==current_id}).worry_op_left=m[1]
        (monkeys.find{|m| m.id==current_id}).worry_op = m[2]
        (monkeys.find{|m| m.id==current_id}).worry_op_right=m[3]
      when /Test:/
        m = /Test: divisible by (\d+)/.match(l)[1]
        # puts "Test Divis factor #{m}"
        (monkeys.find{|m| m.id==current_id}).test_factor = m
      when /If true:/
        m = /If true: throw to monkey (\d+)/.match(l)[1]
        (monkeys.find{|m| m.id==current_id}).true_target=m.to_i
      when /If false:/
        m = /If false: throw to monkey (\d+)/.match(l)[1]
        (monkeys.find{|m| m.id==current_id}).false_target=m.to_i
      else 
        puts "UNKNOWN LINE:#{l}"
    end
  end
  monkeys
end


def silver(input)
  monkeys =  parseMonkey(input)
  modVal = monkeys.reduce(1){|a,m| a*m.test_factor.to_i}

  10000.times do |round|
    for m in monkeys
      puts "Monkey #{m.id}"
      for i in m.items.map(&:to_i)
        m.inspect
        old=i
        result=nil
        puts "  Monkey inspects an item with a worry level of #{old}"
        case m.worry_op
        when "+"
          if m.worry_op_right == "old"
            result = old + old
            puts "    Worry level is added to itself to #{result}"
          else
            result = old + m.worry_op_right.to_i
            puts "    Worry level increases by #{m.worry_op_right} to #{result}"
          end
        when "-"
        when "*"
          if m.worry_op_right == "old"
            result = old * old
            puts "    Worry level is multiplied by itself to #{result}"
          else
            result = old * m.worry_op_right.to_i
            puts "    Worry level is multiplied by #{m.worry_op_right} to #{result}"
          end
        when "/"
        else 
          puts "UNKOWN WORRY OP".red
        end
        test_result = result unless result.nil?
        # test_result = (result / 3).floor unless result.nil?
        puts "    Monkey gets bored with item. Worry level is divided by 3 to #{test_result}"
        test_worry_result = test_result % m.test_factor.to_i
        puts "    Current worry level is divisible by #{m.test_factor}." if test_worry_result == 0
        puts "    Current worry level is not divisible by #{m.test_factor}." unless test_worry_result == 0

        target = test_worry_result==0 ? m.true_target : m.false_target
        puts "    Item with worry level of #{test_result} is thrown to monkey #{target}"
        (monkeys.find{|m| m.id==target}).items.push(test_result%modVal)
      end
      m.items=[]
    end
    puts
    puts "After round #{round+1}"
    for m in monkeys
      print "Monkey #{m.id} inspected items #{m.inspection_count} times."
      puts
    end
  end

  (monkeys.sort_by!{|m| m.inspection_count}).reverse!

  monkeys[0].inspection_count * monkeys[1].inspection_count
end

def gold(input)
  for i in input
    puts i
  end

  "done"
end


# Main execution
@input = read_file_and_chomp(
  case ARGV[0]
  when "silver"
    "silver.txt"
  when "gold"
    "gold.txt"
  else
    "example.txt"
  end
)

puts "Silver: #{silver(@input)}"
# puts "Gold: #{gold(@input)}"
