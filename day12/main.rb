# Advent of Code - Day 12
require_relative "../helpers"

def convert_input_to_hash(input)
  edges = []
  input.each do |segment|
    from, to = segment.split('-')
    puts "Parsing #{segment} into #{from} and #{to}"
    edges.push({
      from: from,
      to: to
    }) unless from == 'end' || to=='start'
    edges.push({
      from: to,
      to: from
    }) unless to == 'end' || from == 'start'
  end
  #edges.each {|e| p e}
  puts
  edges
end

def build_path_to_end(edges, path, indent)
  indent.times {|x| print ' '}
  puts "Building out path #{path}"
  indent.times {|x| print " "} if path.last == 'end'
  puts "Which ends in 'end' so we are done" if path.last=='end'
  return path if path.last == 'end'

  next_paths = edges.select {|e| e[:from]==path.last}.map{|p| p[:to]}

  indent.times {|x| print " "}
  puts "Next path options #{next_paths}"

  built_paths = next_paths.reduce([]) do |m, np| 
    indent.times {|x| print " "}
    puts "Addressing Next Path #{np}"
    if (np.downcase == np && !path.include?(np)) || np.upcase == np
      bp = build_path_to_end(edges, path.clone.push(np), indent+2)
      m.push(bp) unless bp.length == 0 
    end
    m
  end

  indent.times {|x| print " "}
  puts "Built Paths #{built_paths}"

  built_paths
end

def process(ia)
  edges = convert_input_to_hash(ia)
  starting_paths = edges.select {|e| e[:from]=="start"}.map{|e| [e[:from],e[:to]]}
  starting_paths = [starting_paths.first]
  paths = starting_paths.reduce([]){|m, p| m.push(build_path_to_end(edges, p, 0)); m}
  paths.each {|path| puts "path: "; p path}
  nil
end


p "#{process(read_file_and_chomp("test.txt"))}"
