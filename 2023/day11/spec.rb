require_relative 'main2.rb'

describe 'day11' do
  describe 'parse' do
    it 'does the thing' do
      raw = """
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
      """
      output = """
....#........
.........#...
#............
.............
.............
........#....
.#...........
............#
.............
.............
.........#...
#....#.......
      """
      x = Day11.parse(raw)
      expect(x).to eq output.split
    end
  end

  describe 'make_map' do
    it 'gets the right number of galaxies' do
      raw = """
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
      """
      x = Day11.make_map(Day11.parse(raw))
      count = x.select {|l| l.is_galaxy? }.size

      expect(count).to eq 9
    end

    describe 'path_between' do
      it 'knows at least one path' do
        raw = """
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
        """
        map = Day11.make_map(Day11.parse(raw))

        from = map.find {|l| l.label=='5'}.coords
        to = map.find {|l| l.label=='9'}.coords
        x = Day11.path_between(map, from, to)
        expect(x).to eq 9
      end
    end

  end
end