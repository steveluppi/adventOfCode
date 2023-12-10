require_relative 'main.rb'

describe ' today really sucks' do
  it 'can do the very most basic one' do
    raw = """
7-F7-
.FJ|7
SJLL7
|F--J
LJ.LJ
"""
    puts
    expect(gold(raw.split)).to be 4
  end

  it 'can do my own made up one' do
    raw = """
xxx
"""
    puts
    expect(gold(raw.split)).to be 4
  end

  it 'can do the most basic one' do
    raw = """
..........
.S------7.
.|F----7|.
.||OOOO||.
.||OOOO||.
.|L-7F-J|.
.|II||II|.
.L--JL--J.
..........
"""
    puts
    expect(gold(raw.split)).to be 4
  end

  it 'can do the basic one' do
    raw = """
...........
.S-------7.
.|F-----7|.
.||.....||.
.||.....||.
.|L-7.F-J|.
.|II|.|II|.
.L--J.L--J.
...........
"""
    puts
    expect(gold(raw.split)).to be 4
  end

  it 'can do the slightly harder one' do
    raw = """
......................
..F----7F7F7F7F-7.....
..|F--7||||||||FJ.....
..||.FJ||||||||L7.....
.FJL7L7LJLJ||LJ.L-7...
.L--J.L7...LJS7F-7L7..
.....F-J..F7FJ|L7L7L7.
.....L7.F7||L7|.L7L7|.
......|FJLJ|FJ|F7|.LJ.
.....FJL-7.||.||||....
.....L---J.LJ.LJLJ....
"""

  puts
  expect(gold(raw.split)).to be 8
  end

  it 'can do the slightly harder one with junk' do
    raw = """
FF7FSF7F7F7F7F7F---7
L|LJ||||||||||||F--J
FL-7LJLJ||||||LJL-77
F--JF--7||LJLJ7F7FJ-
L---JF-JLJ.||-FJLJJ7
|F|F-JF---7F7-L7L|7|
|FFJF7L7F-JF7|JL---7
7-L-JL7||F7|L7F-7F7|
L.L7LFJ|||||FJL7||LJ
L7JLJL-JLJLJL--JLJ.L
"""
    puts
    expect(gold(raw.split)).to be 10
  end

  # it 'can do my real one' do
  #   raw = read_file_and_chomp('silver.txt')
  #   expect(gold(raw)).to be 100
  # end
end
