# Advent of Code - Day 13
require_relative "../helpers"

def print_graph2(title, graph)
  max_col = graph.reduce(0) do |memo, row|
    row.each_index {|col| memo = col > memo ? col : memo} unless row.nil?
    memo
  end

  puts
  puts "-- #{title}--"
  graph.each do |row|
    row=[] if row.nil?
    for c in 0..max_col do
      print row[c].nil? ? " " : '#' 
    end
    puts
  end
  puts "-----------"
  puts
end
def print_graph(title, graph)
  return
  max_col = graph.reduce(0) {|memo, row|
    row.each_index {|col| memo = col > memo ? col : memo} unless row.nil?
    memo
  }

  puts
  puts "-- #{title}--"
  graph.each do |row|
    row=[] if row.nil?
    for c in 0..max_col do
      print row[c].nil? ? "." : '#' 
    end
    puts
  end
  puts "-----------"
  puts
end

def pull_dots_and_folds(input)
  max_x, max_y = 0,0
  dots = input.reject{|x| /fold along/.match?(x)||x.empty?}.reduce([]) do |memo, line|
    x,y = line.split(',').map!(&:to_i)
    memo[x] ||= []
    memo[x][y] = '#'
    max_x = x if x>max_x
    max_y = y if y>max_y
    memo
  end

  puts "Max x and y #{max_x} #{max_y}"

  print_graph("Parsed Dots", dots)
  folds = input.select{|x| /fold along/.match?(x)}.reduce([]) do |memo, line|
    direction, count = line.scan(/[x|y]=\d+/).pop.split('=')
    memo.push({direction: direction, on: count.to_i})
    memo
  end
  [dots, folds]
end

def process(input)
  graph, folds = pull_dots_and_folds(input)

  # Do some folds
  folds.each do |fold|
    if fold[:direction] == 'x'
      puts "Do a y fold #{fold} with starting graph length #{graph.length}"
      before_length = graph.length
      puts "Slice graph on #{fold[:on]+1}"
      lower = graph.slice(fold[:on]+1..).reverse
      puts "Slice! graph on #{fold[:on]}"
      graph.slice!(fold[:on]..)
      print_graph("Upper", graph)
      print_graph("Lower", lower)

      abort "Upper #{graph.length} and Lower #{lower.length} are diff" if graph.length != lower.length
      # abort "Missing rows from #{before_length} in #{graph.length} and #{lower.length}" if before_length-1 != graph.length+lower.length
      
      lower.each_with_index do |row, row_index|
        row.each_with_index do |col, col_index|
          next if col.nil?
          graph[row_index] ||= []
          graph[row_index][col_index] = '#' 
        end unless row.nil?
      end
      print_graph("Y Folded", graph)
    else
      puts "Do a x fold #{fold} with graph length #{graph.length}"
      left, right = [], []
      
      # Split the graph
      graph.each do |row|
        if row.nil?
          right.push(nil)
          left.push(nil)
          next
        end

        right.push(row.slice(fold[:on]+1..))
        left.push(row.slice(0..fold[:on]-1))
      end

      abort "Right #{right.length} and Left #{left.length} are diff" if right.length != left.length

      # Print the split
      print_graph("Before X Fold", graph)
      print_graph("Left", left)
      print_graph("Right", right)

      # fill in the right side as needed
      max_graph_col = graph.reduce(0) do |memo, row|
        row.each_index {|col| memo = col > memo ? col : memo} unless row.nil?
        memo
      end
      max_col_left = left.reduce(0) do |memo, row|
        row.each_index {|col| memo = col > memo ? col : memo} unless row.nil?
        memo
      end
      max_col_right = right.reduce(0) do |memo, row|
        row.each_index {|col| memo = col > memo ? col : memo} unless row.nil?
        memo
      end
      max_col = [max_col_left, max_col_right].max
      puts "max_col is #{max_col} which comes from #{max_col_left} and #{max_col_right} as compared to #{max_graph_col}"
      # puts "max graph - 1 div 2 = #{(max_graph_col-1)/2}"

      abort "What is goign on with this" if (max_graph_col-1)/2 > max_col

      right.map! do |row|
        # puts "Attempt to reverse row #{row}"
        next nil if row.nil?
        while(row.length < max_col+1)
          row.push(nil)
        end
        # puts "row is now #{row.reverse}"
        row.reverse
      end
      print_graph("Flipped Right", right)

      # Merge
      right.each_with_index do |row, row_index|
        row.each_with_index do |col, col_index|
          left[row_index] ||= []
          left[row_index][col_index] = col unless col.nil?
        end unless row.nil?
      end
      print_graph("Folded X", left)
      puts "Folded X with new graph length of #{left.length}"
      graph = left
    end
    print_graph("Step Complete", graph)

    puts "Enter to continue"
    # gets.chomp
  end

  p graph.reduce(0){|memo, row|
    memo += row.reduce(0) {|m,c| m+=1 unless c.nil?; m} unless row.nil?
    memo
  }

  print_graph2("End", graph)

  nil
end

puts "#{process(read_file_and_chomp("input.txt"))}"
