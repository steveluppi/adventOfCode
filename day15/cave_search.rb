def process(cave)
  position = [0,0]
  max_v = cave.sort_by {|k,v| v[:v]}.reverse.first[1][:v]
  max_h = cave.sort_by{|k,v| v[:h]}.reverse.first[1][:h]
  cave["0,0"][:visited] = true;
  cave["0,0"][:dist] = 0

  loop do 
    cv, ch = position
    current = cave["#{cv},#{ch}"]
    break if ch == max_h && cv == max_v
    up = cave["#{cv-1},#{ch}"]
    down = cave["#{cv+1},#{ch}"]
    left = cave["#{cv},#{ch-1}"]
    right = cave["#{cv},#{ch+1}"]
    # p up, down, left, right

    possibilities = [up,down,left,right].reject{|v|v.nil? || v[:visited]}
    possibilities.map do |pos|
      new_dist = pos[:cost] + current[:dist]
      if pos[:dist].nil? || new_dist < pos[:dist]
        pos[:dist] = new_dist 
        pos[:from] = position 
        pos[:in_q] = true
      end
      pos
    end

    move_to = cave.filter{ |k,v| v[:in_q] && !v[:visited]}.sort_by{|k,v| v[:dist]}.first[1]
    move_to[:visited] = true
    position = [move_to[:v], move_to[:h]]

    # print_cave("After iteration", cave)
  end

  puts "Found Ending position!!!!"
  # print_path(cave, coords)

  cost = cave["#{max_v},#{max_h}"][:dist]
  cost
end

