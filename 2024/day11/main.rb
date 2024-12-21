require_relative '../../helpers'
require 'io/console'
require 'set'

$debug = true
class Minecart
  attr_accessor :value
  attr_reader :count

  def initialize(value, count=1)
    @value = value
    @count = count 
  end
  def add num
    @count += num
  end
  def splits?
    @value.to_s.length%2==0
  end
  def zero?
    @value == 0
  end
  def mult2024
    @value *= 2024
  end

  def inspect
    "#{@value}"
  end
  def to_s
    "#{@value}"
  end
end
class AOC
  def self.silver(lines)
    rocks = lines.first.split(' ')
    debugp rocks
    75.times do |blink|
      output = []
      rocks.each do |rock|
        if rock == "0"
          output << "1"
        elsif (rock.length % 2 == 0)
          output << rock[0..(rock.length/2)-1].to_i.to_s
          output << rock[rock.length/2..].to_i.to_s
        else
          output << (rock.to_i * 2024).to_s
        end
      end

      # debugp output
      rocks = output
    end

    rocks.length
  end

  def self.gold(lines)
    rocks = lines.first.split(' ').map{|r| Minecart.new(r.to_i)}

    75.times do |blink|
      debugp rocks
      rocks.map! do |mc|
        if mc.zero?
          mc.value = 1
          mc
        elsif mc.splits?
          rock = mc.value.to_s
          val1 = rock[0..(rock.length/2)-1].to_i
          val2 = rock[rock.length/2..].to_i
          [Minecart.new(val1, mc.count), Minecart.new(val2, mc.count)]
        else
          mc.mult2024
          mc
        end
      end
      rocks.flatten!
      output = []
      rocks.group_by{|mc| mc.value}.each do |mc|
        if mc[1].length == 1
          output << mc[1]
        else
          output << Minecart.new(mc[0], mc[1].map{|m| m.count}.sum)
        end
      end
      rocks = output.flatten
    end
    rocks.map(&:count).sum
  end
end
