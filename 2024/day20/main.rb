require_relative '../../helpers'
require 'io/console'
require 'set'

class AOC
  def self.silver(lines)
    $grid = lines
    $mr = lines.length-1
    $mc = lines.first.length-1
    
    debug "Here is the grid:".blue
    print_grid true

    $start, $end = [nil, nil]

    # need to find start and end
    debug "Looking for start and end points".blue
    for r in 0..$mr do
      for c in 0..$mc do
        $start = [r,c] if $grid[r][c] == 'S'
        $end = [r,c] if $grid[r][c] == 'E'
      end
    end

    # Setup the loop
    pathfinder = AOC.find_path
    
    the_path = pathfinder.path.to_a
    the_path << "#{$end.first},#{$end.last}"
    debugp the_path
    pathfinder.print_path

    scores = []
    the_path.each_with_index do |step, idx|
      debug "working on index #{idx} of #{step}".blue
      r,c = step.split(',').map(&:to_i)

      # does cheating N result in being back on the path
      if the_path.include?("#{r-2},#{c}") and $grid[r-1][c]=='#'
        debug "Cheat North".red
        save=the_path.index("#{r-2},#{c}")-idx
        debug "  saves #{save}".red
        scores << save-2
      end

      # does cheating E result in being back on the path
      if the_path.include?("#{r},#{c+2}") and $grid[r][c+1]=='#'
        debug "Cheat EAST".red
        save=the_path.index("#{r},#{c+2}")-idx
        debug "  saves #{save}".red
        scores << save-2
      end

      # does cheating W result in being back on the path
      if the_path.include?("#{r},#{c-2}") and $grid[r][c-1]=='#'
        debug "Cheat WEST".red
        save=the_path.index("#{r},#{c-2}")-idx
        debug "  saves #{save}".red
        scores << save-2
      end

      # does cheating S result in being back on the path
       if the_path.include?("#{r+2},#{c}") and $grid[r+1][c]=='#'
        debug "Cheat SOUTH".red
        save=the_path.index("#{r+2},#{c}")-idx
        debug "  saves #{save}".red
        scores << save-2
       end
    end

    scores.reject!{|s| s<0}
    debugp scores.sort
    puts
    debugp scores.group_by{|s|s}

    count = 0
    scores.group_by{|s|s}.to_a.each do |score|
      count += score.last.length if score.first >= 100
    end

    # pathfinder.score
    count
  end
  def self.find_path
    q = [Pathfinder.new(r: $start.first, c: $start.last)]
    seen = []

    loop do
      # sort to the lowest priority
      q.sort_by!(&:score)
      # grab something to work on
      work = q.shift

      # note the location as seen
      debug "note the location #{work.location} as seen".gray
      seen << work.location

      if work.is_end?
        debug "*** We found the end ***".on_green
        debugp work
        # work.print_path
        return work
      end

      work.direction[:turns].each do |nh|
        debug " can we turn #{nh}?".grey
        to = work.to(nh)
        nr, nc = to
        debug "   which puts us at #{to}".grey

        if $grid[nr][nc] != '#' and !seen.include?("#{nr},#{nc},#{nh}")
          debug " yes we can! let's go".green
          q << Marshal.load(Marshal.dump(work)).forward(nh)
        else
          debug " no we can't".red
        end
      end

      break if q.empty?
    end
  end

  def self.in_grid(r,c)
    r >= 0 and r<=$mr and c>=0 and c<=$mc
  end

  def self.gold(lines)
    $grid = lines
    $mr = lines.length-1
    $mc = lines.first.length-1
    
    debug "Here is the grid:".blue
    print_grid true

    $start, $end = [nil, nil]

    # need to find start and end
    debug "Looking for start and end points".blue
    for r in 0..$mr do
      for c in 0..$mc do
        $start = [r,c] if $grid[r][c] == 'S'
        $end = [r,c] if $grid[r][c] == 'E'
      end
    end

    # Setup the loop
    pathfinder = AOC.find_path
    
    the_path = pathfinder.path.to_a
    the_path << "#{$end.first},#{$end.last}"
    debugp the_path
    pathfinder.print_path

    # Work on the cheats
    cheats = []
    pb = ProgressBar.new(the_path.length)
    the_path.each_with_index do |step, idx|
      pb.increment!
      debug "working on index #{idx} of #{step}".blue
      r,c = step.split(',').map(&:to_i)

      cheat_to = []
      for cr in ([(r-20),0].max)..([(r+20),$mr].min) do
        diff = 20 - (r-cr).abs
        for cc in (c-diff)..(c+diff) do
          coord = "#{cr},#{cc}"
          debug " cheat #{coord}".gray if AOC.in_grid(cr, cc)

          if AOC.in_grid(cr,cc) and the_path.include?(coord)
            cheat_idx = the_path.index(coord)
            cheat_to << (cheat_idx - idx) - ((r-cr).abs + (c-cc).abs)
          end
        end
      end
      debugp cheat_to

      cheats << cheat_to.flatten
    end
    cheats.flatten!.reject!{|s| s < 100}.sort!
    # cheats.group_by{|s| s}.each{|s,v| puts "#{v.length} cheats of #{s}"}
    cheats.length
  end
end
