require_relative '../../helpers'
require 'io/console'
require 'set'

$debug = false
class AOC
  def self.silver(lines)
    towel_lines = []
    loop do
      work = lines.shift
      break if work.empty?
      towel_lines << work
    end

    $towels = towel_lines.map{|t| t.split(', ')}.flatten.sort_by(&:length).reverse
    debugp $towels
    puts

    pb = ProgressBar.new(lines.length)
    matched = lines.map do |pattern|
      debug ""
      debug "Looking at string #{pattern}".blue
      pb.puts(pattern)
      pb.increment!
      AOC.search(pattern)
    end

    debugp matched
    matched.sum
  end

  $memo = {}
  def self.search(pattern)
    debug "Search with #{pattern}"
    # debugp $memo
    if pattern==""
      debug " Nothing left to search".green
      return 1
    end

    unless $memo[pattern].nil?
      debug " NOT FOUND FROM MEMO".red
      return $memo[pattern]
    end

    found = 0
    $towels.select do |t|
      debug " attempt #{t}"
      debug " match with #{t}".gray if pattern.start_with?(t)
      f = AOC.search(pattern[t.length..]) if pattern.start_with?(t)
      found += f unless f.nil?

      !f.nil?
    end

    $memo[pattern] = found

    debug " NOT FOUND".red unless found
    debug " FOUND".green if found

    found
  end

  def self.do_silver_poorly(towels, lines)
    debug "Starting lines loop".green
    matched = lines.select do |pattern|
      debug ""
      debug " Let's find a match for #{pattern}".blue
      debug " Set search index to zero"
      debug " Start the towels loop"
      search_idx = 0
      loop do
        print "   "
        pattern.split('').each_with_index{|l,i| print i==search_idx ? l.green : l}
        puts
        next_t = towels.find{|t| pattern.index(t, search_idx) == search_idx}
        debug "    Matched on #{next_t}" unless next_t.nil?
        break if next_t.nil?
        search_idx += next_t.length
      end
      debug " End the towels loop"
      debug " with success".green if search_idx == pattern.length
      debug " without success".red unless search_idx == pattern.length
      search_idx == pattern.length
    end
    debug ""
    debug "End lines loop"
    debugp matched
    matched.size
  end

  def self.gold(lines)
  end
end
