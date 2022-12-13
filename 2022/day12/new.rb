class Node
  # attr_accessor :first_name, :last_name, :email, :username, :password
  attr_accessor :value, :key, :up, :down, :left, :right, :isEnd, :orig_val

  @value
  @orig_val
  @key
  @up
  @down
  @left
  @right
  @isEnd

  def initialize(value, coords)
    @orig_val = value
    @value = value.to_i(36) unless value == value.upcase
    @value = "a".to_i(36) if value == "S"
    @value = "z".to_i(36) if value == "E"
    @isEnd = false
    @key = "#{coords[0]},#{coords[1]}"
  end

  def setConnections(up, down, left, right)
    @up = up unless up.nil?
    @down = down unless down.nil?
    @left = left unless left.nil?
    @right = right unless right.nil?
  end
  def to_s
    "#{key} - #{value}"
  end
end

def key(y, x)
  "#{y},#{x}"
end

def buildMap(input)
  p input
  p input.length
  p input[0].length
  cave = {}
  for y in 0..input.length-1 do
    for x in 0..input[y].length-1 do
      # puts "Build #{y}, #{x}"
      node = cave[key(y,x)] || Node.new(input[y][x], [y,x])
      up = key(y-1,x)
      down = key(y+1,x)
      left = key(y,x-1)
      right = key(y,x+1)
      # p up,down,left,right

      node.setConnections(up, down, left, right)

      node.isEnd = true if input[y][x] == "E"

      # up.down = node unless up.nil?
      # down.up = node unless down.nil?
      # left.right = node unless left.nil?
      # right.left = node unless right.nil?

      cave[key(y,x)] = node
      # p node
      # p cave.keys
    end
  end

  # p cave.keys.length
  # p cave.values.length
  cave
end

def find_path(start, cave)
  unvisited = cave.keys.reduce({}){|memo, key| memo[key]=nil; memo}
  tentative = cave.keys.reduce({}) do |memo, key|
    memo[key] = key=="0,0" ? 0 : nil
    memo
  end
  not_infinite = {}
  
  current = start
 
  loop do
    puts "At #{current.key}"
    up = cave[current.up]
    down = cave[current.down]
    left = cave[current.left]
    right = cave[current.right]
    # p up, down, left, right
    [up, down, left, right].reject{|x|x.nil?}.each do |neighbor|
      # puts "Checking #{neighbor}"
      if unvisited.keys.include?(neighbor.key)
        old_tentative = tentative[neighbor.key]
        new_tentative = tentative[current.key] + neighbor.value
        tentative[neighbor.key] = new_tentative if old_tentative.nil? || new_tentative < old_tentative
        # not_infinite.push(neighbor.key)
        not_infinite[neighbor.key]=nil
      end
    end

    # unvisited.reject!{|x| x==current.key}
    unvisited.delete(current.key)
    # not_infinite.reject!{|x| x==current.key}
    not_infinite.delete(current.key)

    break if current.isEnd==true
    
    next_up = not_infinite.keys.reduce(nil) do |memo, nik|
      if memo.nil?
        memo=nik
      else
        memo_val = tentative[memo]
        nik_val = tentative[nik]
        memo = nik if nik_val < memo_val
      end
      memo
    end
    current = cave[next_up]
  end

  puts "done"
  p current
  p tentative[current.key]
end

def parse_cave(file_path)
  File.readlines(file_path).map(&:chomp).map{|l| l.split("")}
end
def bigger_cave(input)
  big_cave = []
  input.each do |line|
    p line
    new_line = []
    5.times do |iter|
      p iter
      line.each_with_index do |val, index|
        p val+index
        new_line.push(val+iter)
      end
    end
    new_line.map!{|x|x>9?x-9:x}
    big_cave.push(new_line)
  end
  bigger_cave = []
  4.times do |iter|
    bigger_cave.concat(big_cave.map{|l| l.map{|v| v+iter+1}})
  end
  bigger_cave.map!{|l| l.map!{|v|v>9?v-9:v}}
  big_cave.concat(bigger_cave)
  big_cave
end

# cave = buildMap(parse_cave("test.txt"))
# cave = buildMap(bigger_cave(parse_cave("input.txt")))
# cave.each{|l|l.each{|v| print v}; puts}
cave = buildMap(parse_cave("example.txt"))

# find_path(cave["0,0"], cave)
