# Advent of Code - Day x
require_relative "../helpers"

def process(input, days)
  # p input
  days.times do |i|
    puts i
    # puts input.count(0)
    input.count(0).times{|i| input.push(9)}
    input.map!{|i| i==0?7:i }
    input.map!(&:pred)
    # p input
  end
  puts "---"
  input.length
end

def process_hash(input, days)
  spawn_count = Array.new(9,0)
  input.each {|i| spawn_count[i]+=1}

  days.times do |i|
    p i
    spawns = spawn_count.shift
    spawn_count[8]=spawns
    spawn_count[6]+=spawns
  end

  puts "---"
  spawn_count.reduce(0,&:+)
end


puts "#{process_hash(read_file_to_array("input.txt"), 256)} fish"
