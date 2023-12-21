require_relative '../../helpers'
require 'io/console'
require 'set'
require 'awesome_print'

class CableModule
  attr_reader :destinations, :name, :type

  def initialize(name, type, destinations)
    @name = name
    @type = type
    @destinations = destinations
    @status = false
    @past = {}
  end

  def pulse(incoming, from=nil)
    case @type
    when 'button'
      return 'low'
    when 'broadcaster'
      return incoming
    when '%'
      return nil if incoming == 'high'
      @status = !@status
      return @status ? 'high' : 'low'
    when '&'
      # ap @past
      @past[from] = incoming
      # ap @past
      return @past.values.all?{|v| v=='high'} ? 'low' : 'high'
    else
      throw "WEIRD PULSE TYPE"
    end
  end

  def is_on?
    @status
  end

  def goes_to?(dest)
    @destinations.include? dest
  end

  def add_input(from)
    puts "Adding to #{@name} an input from #{from}"
    @past[from] = 'low'
  end

  def inspect
    "Module #{@name}: #{@type} -> #{@destinations.join(',')} #{@past.keys}"
  end
  def to_s
    "Module #{@name}: #{@type} -> #{@destinations.join(',')} #{@past.keys}"
  end
end

class AOC
  def self.parse(lines)
    gates = {}
    gates['button'] = CableModule.new('button','button', ['broadcaster'])
    lines.each do |line|
      break if line == 'stop'
      gate, dest = line.split('->').map(&:strip)
      case gate[0]
      when 'b'
        gates[gate] = CableModule.new('broadcaster', 'broadcaster', dest.split(',').map(&:strip))
      when '%', '&'
        gates[gate[1..]] = CableModule.new(gate[1..], gate[0], dest.split(',').map(&:strip))
      else
        throw 'WEIRD GATE'
      end
    end

    gates.values.each do |g|
      if g.type == '&'
        dest = g.name
        gates.values.select {|ga| ga.goes_to? dest}.each {|ga| g.add_input ga.name}
      end
    end

    gates
  end
  def self.silver(lines)
    operations = []
    gates = parse(lines)
    puts "Gates for this run are:".green
    ap gates
    pulses = {'high'=>0, 'low'=>0}
    pushes = 0
    # 10000000.times do |iter|
    loop do 
      operations << [gates['button'], nil, nil]
      pushes += 1
      loop do 
        # puts "Starting loop with operaionts #{operations}"
        current_op, incoming_pulse, from = operations.shift
        # puts "Working on #{current_op}"
        pulse = current_op.pulse(incoming_pulse, from)
        current_op.destinations.each do |dest|
          break if pulse.nil?
          # puts "Sending #{pulse} to #{dest}"
          # puts "#{current_op.name} -#{pulse}->#{dest}"
          pulses[pulse] += 1
          # throw "WTF" if gates[dest].nil?
          # throw iter if pulse == 'low' and dest == 'rx'
          if dest == 'rx'
            if pulse == 'low'
              puts "FOUND LOW TO RX".green
              throw pushes
            else
              puts "found high to rx...keep going".red
            end
          end
          operations << [gates[dest], pulse, current_op.name] unless gates[dest].nil?
        end
        break if operations.length < 1
        # break if pulses > 12
      end
      puts
    end
    p pulses
    pulses.values.inject(:*)
  end

  def self.gold(lines)
  end
end
