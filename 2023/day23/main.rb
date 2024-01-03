require_relative '../../helpers'
require 'io/console'
require 'awesome_print'
require 'set'

class Tile
  attr_reader :label, :row, :col
  def initialize(label, row, col)
    @label = label
    @row = row
    @col = col
  end

  def is_tree?
    return @label == '#'
  end

  def is_start?
    return @label == 'S'
  end
  
  def coords
    [@row, @col]
  end

  def north_to
    [@row - 1, @col]
  end

  def south_to
    [@row + 1, @col]
  end

  def west_to
    [@row, @col - 1]
  end

  def east_to
    [@row, @col + 1]
  end
end

class AOC
  def self.print_grid(g, s, r, c)
    (0..r).each do |row|
      (0..c).each do |col|
        t = g[[row,col]]
        print t.is_tree? ? t.label.red : s.include?(t.coords) ? t.label.green : t.label
      end
      puts
    end
  end

  def self.parse_silver(lines)
    grid = {}
    max_row = lines.length-1
    max_col = lines[0].length-1
    lines.each_with_index do |row, row_index|
      row.chars.each_with_index do |col, col_index|
        grid[[row_index, col_index]] = Tile.new(col, row_index, col_index)
      end
    end
    [grid, max_row, max_col]
  end

  def self.parse_gold(lines)
    grid = {}
    max_row = lines.length-1
    max_col = lines[0].length-1
    lines.each_with_index do |row, row_index|
      row.chars.each_with_index do |col, col_index|
        col = '.' if ['v','^', '>', '<'].include? col
        grid[[row_index, col_index]] = Tile.new(col, row_index, col_index)
      end
    end
    [grid, max_row, max_col]
  end

  def self.silver(lines)
    grid, max_row, max_col = parse_silver lines
    do_silver(grid, max_row, max_col)
  end

  def self.do_silver(grid, max_row, max_col)
    seen = []
    stack = []
    total_distances = []

    print_grid(grid, seen, max_row, max_col)

    start = grid.values.find {|t| t.is_start? }
    seen << start.coords
    stack << seen
    loop do
      current_seen = stack.pop
      current_tile = grid[current_seen.last]
      if current_tile.row == max_row
        # if current_seen.length > 100
        #   p current_seen
        #   print_grid(grid, current_seen, max_row, max_col)
        #   throw "THis should not happen"
        # end
        total_distances << current_seen.length-1
        p total_distances.sort
        break if stack.length < 1
        next
      end
      n = grid[current_tile.north_to]
      s = grid[current_tile.south_to]
      w = grid[current_tile.west_to]
      e = grid[current_tile.east_to]

      # p n,s,e,w
      unless n.nil? or n.is_tree? or current_seen.include? n.coords or n.label == 'v'
        new_current = current_seen.clone
        new_current << n.coords
        stack << new_current
      end
      unless s.nil? or s.is_tree? or current_seen.include? s.coords or s.label == '^'
        new_current = current_seen.clone
        new_current << s.coords
        stack << new_current
      end
      unless w.nil? or w.is_tree? or current_seen.include? w.coords or w.label == '>'
        new_current = current_seen.clone
        new_current << w.coords
        stack << new_current
      end
      unless e.nil? or e.is_tree? or current_seen.include? e.coords or e.label == '<'
        new_current = current_seen.clone
        new_current << e.coords
        stack << new_current
      end

      # pp stack
      # print_grid(grid, current_seen, max_row, max_col)
      # q_to_quit
      break if stack.length < 1
    end

    p total_distances.sort
    total_distances.sort.last
  end

  def self.gold(lines)
    grid, max_row, max_col = parse_gold lines

    print_grid(grid, [], max_row, max_col)

    do_silver(grid, max_row, max_col)
  end

  def self.q_to_quit
    x=$stdin.getch
    exit if x == 'q'
  end
end
