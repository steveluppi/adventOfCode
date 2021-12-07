# Advent of Code - Day 5
require_relative "../helpers"

def parse_input(input)
  init_graph = []
  input.each do |input_line|
    x1,y1,x2,y2 = input_line.gsub(' -> ',',').split(',').map { |x| x.to_i}
    puts "-- Parsing Input Line --"
    puts input_line
    puts "x1: #{x1}  y1:#{y1} -> x2: #{x2}  y2: #{y2}"
    # puts "x1: #{x1.class}  y1:#{y1.class} -> x2: #{x2.class}  y2: #{y2.class}"
    # handle vertical line
    if x1 == x2
      from = y1 < y2 ? y1 : y2
      to = y1 > y2 ? y1 : y2
      init_graph[x1] = [] if init_graph[x1].nil?
      for i in from..to do
        init_graph[i] ||= [] 
        init_graph[i][x1] ||= 0
        init_graph[i][x1] += 1
      end
    elsif y1==y2 # handle horizontal line
      from = x1 < x2 ? x1 : x2
      to = x1 > x2 ? x1 : x2
      for i in from..to do
        init_graph[y1] ||= []
        init_graph[y1][i] ||= 0
        init_graph[y1][i] += 1 
      end
    else
      puts "DIAGONAL"
      slope = (x2-x1)/(y2-y1)
      puts "Slope for diagonal line is #{slope}"
      horizontal_shift = x2<x1 ? -1 : 1
      puts "shift #{horizontal_shift}"
      x,y = x1,y1
      puts "starting x y #{x} #{y}"
      init_graph[y] ||= []
      init_graph[y][x] ||= 0
      init_graph[y][x] +=1
      loop do
        x += horizontal_shift
        y += (slope * horizontal_shift)
        init_graph[y] ||= []
        init_graph[y][x] ||= 0
        init_graph[y][x] +=1
        puts "Check new x,y #{x} #{y}"
        break if  x == x2 && y==y2
      end
    end
    puts "------------------------"
    puts
    # print_graph(init_graph)
  end
  init_graph
end

def print_graph(graph)
  puts "-- Graph --"
  graph.each do |row|
    row=[] if row.nil?
    row.each { |p| print p.nil? ? "." : p } 
    puts
  end
  puts "-----------"
end

def plot_line(graph, points)

end

def count_intersections(graph)
  count = 0
  graph.each do |row|
    row = [] if row.nil?
    row.each {|p| count+=1 if !p.nil? &&  p>=2}
  end
  count
end

def process(input)
  graph = parse_input(input)
  
  print_graph(graph)
  count_intersections(graph)
end

puts "#{process(read_file_and_chomp("input.txt"))} intersections"
# puts "#{process(read_file_and_chomp("test.txt"))} intersections"
