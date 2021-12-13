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

  puts
  edges
end

def determine_next_paths(edges, last)
  edges.select {|e| e[:from]==last}.map{|p| p[:to]}
end

def build_path_to_end(edges, path, known_paths, indent)
  i_log("Building out path #{path}", indent)

  if path.last == 'end'
    i_log("Which ends in 'end' so we are done", indent)
    known_paths.push(path)
    # i_log("Returning #{known_paths}", indent)
    return known_paths
  end
  
  next_paths = determine_next_paths(edges, path.last)
  i_log("Next path options #{next_paths}", indent)

  next_paths.each do |np| 
    i_log("Addressing Next Path #{np}", indent)

    np_is_upcase = np.upcase == np
    downcase_count = path.filter{|x|x.downcase==x}.count
    uniq_downcase_count = path.filter{|x|x.downcase==x}.uniq.count
    np_in_path = path.filter{|x|x==np}.count

    i_log("downcase_count #{downcase_count}, uniq_downcase_count #{uniq_downcase_count}, np_in_path #{np_in_path}", indent)

    if np.upcase == np || np_in_path==0 || (np_in_path == 1 && downcase_count == uniq_downcase_count)
      i_log("#{np} in block", indent)
      known_paths = build_path_to_end(edges, path.clone.push(np),known_paths, indent+2)
    end
    # if (np.downcase == np && path.select{|x|x==np}.count<2) || np.upcase == np
    #   known_paths = build_path_to_end(edges, path.clone.push(np),known_paths, indent+2)
    # end
  end

  # i_log("Known Paths #{known_paths}", indent)
  known_paths
end

def process(ia)
  edges = convert_input_to_hash(ia)
  starting_paths = edges.select {|e| e[:from]=="start"}.map{|e| [e[:from],e[:to]]}
  known_paths = []
  starting_paths.each{|p| known_paths = build_path_to_end(edges, p, known_paths, 0)}
  known_paths.each {|path| puts "path: "; p path}

  puts; puts;
  known_paths.length
end


# p "#{process(read_file_and_chomp("test.txt"))}"
p process(read_file_and_chomp("input.txt"))
