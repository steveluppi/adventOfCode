require_relative '../../helpers'
require 'io/console'
require 'set'

DEBUG = false

class AOC
  def self.silver(lines)
    lines=lines.join('')
    lines = lines.split(',')

    nums = lines.map do |line|
      hash(line)
    end
    nums.inject(&:+)
  end

  def self.hash(text)
    current=0
    text.chars.each do |c|
      current += c.ord
      current *= 17
      current %= 256
    end
    current
  end

  def self.gold(lines)
    boxes = {}
    lines=lines.join
    lines=lines.split(',')

    lines.each do |operation|
      label = operation.scan(/(.+)[-=]/).flatten.pop
      box = hash label
      
      puts if DEBUG
      puts "Operation #{operation} has label #{label} which is box #{box}" if DEBUG

      if operation.include? '-'
        puts "  which is a remove operation" if DEBUG
        box_for_op = boxes[box]
        puts "  from the current box #{box_for_op || 'nil'}" if DEBUG
        next if box_for_op.nil?
        puts "  and we should be able to remove" if DEBUG
        boxes[box].reject! {|b| b[:label] == label}
      elsif operation.include? '='
        focal_length = operation.scan(/=(\d+)/).flatten.pop
        puts "  which is an add operation with focal length #{focal_length}" if DEBUG
        box_for_op = boxes[box]
        puts "  from the current box #{box_for_op || 'nil'}" if DEBUG
        if box_for_op.nil?
          puts "  box was empty, just add it" if DEBUG
          box_for_op = [{label: label, focal_length: focal_length}]
          boxes[box] = box_for_op
        else
          puts "  box was not empty, lets find a match first" if DEBUG
          lens = box_for_op.find_index {|b| b[:label] == label}
          puts "  lens #{lens.nil? ? 'not found' : 'found!'}  -  #{lens}" if DEBUG
          if lens.nil?
            boxes[box].push({label: label, focal_length: focal_length})
          else
            boxes[box][lens][:focal_length] = focal_length
          end
        end
      else 
        throw 'WTF'
      end
    end
    pp boxes if DEBUG
    
    sum = 0
    boxes.each do |box, value|
      pp box if DEBUG
      pp value if DEBUG
      value.each_with_index do |lens, idx|
        sum += (box + 1) * (idx + 1) * lens[:focal_length].to_i
      end
    end

    sum
  end
end
