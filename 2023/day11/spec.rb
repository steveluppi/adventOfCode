require_relative 'main2.rb'

describe 'day11' do
  before do
    @raw = """
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
    @raw_output = """
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
    @silver = read_file_and_chomp('silver.txt')
  end

  describe 'parse' do
    it 'does the thing' do
      x = Day11.parse(@raw.split)
      expect(x).to eq @raw_output.split
    end
  end

  describe 'make_map' do
    it 'gets the right number of galaxies' do
      x = Day11.make_map(Day11.parse(@raw.split))
      count = x.select {|l| l.is_galaxy? }.size

      expect(count).to eq 9
    end
  end

  describe 'path set' do
    it 'knows all the paths it should make' do
      map = Day11.make_map(Day11.parse(@raw.split))
      paths = Day11.path_set(map)
      expect(paths.size).to eq 36
    end
  end

  describe 'path_between' do
    it 'knows a straight line when it sees one' do
      map = Day11.make_map(Day11.parse(@raw.split))
      from = map.find {|l| l.label=='8'}.coords
      to = map.find {|l| l.label=='9'}.coords
      three = map.find {|l| l.label=='3'}.coords
      x = Day11.path_between(map, from, to)
      y = Day11.path_between(map, three, from)
      expect(x).to eq 5
      expect(y).to eq 9
    end

    it 'knows at least one path' do
      map = Day11.make_map(Day11.parse(@raw.split))

      from = map.find {|l| l.label=='5'}.coords
      to = map.find {|l| l.label=='9'}.coords
      x = Day11.path_between(map, from, to)
      expect(x).to eq 9
    end
  end

  describe 'all together now' do
   it 'can do the basic puzzle' do
      map = Day11.make_map(Day11.parse(@raw.split))

      set = Day11.path_set(map)
      lengths = set.map do |labels|
        # p labels
        from_label, to_label = labels.map(&:to_s)
        from = map.find {|l| l.label == from_label }
        to = map.find {|l| l.label == to_label }
        Day11.path_between(map, from.coords, to.coords)
      end
      expect(lengths.inject(:+)).to be 374
    end

    xit 'can do one silver path' do
      parsed = Day11.parse(@silver)
      map = Day11.make_map(parsed)

      # printed=0
      # (0..parsed.length-1).each do |r|
      #   (0..parsed[0].length-1).each do |c|
      #     pos = map.find {|l| l.is?(r,c) }
      #     print '#'.red if pos.label == '1' or pos.label == '21'
      #     printed+=1 if pos.label == '1' or pos.label == '21'
      #     next if pos.label == '1' or pos.label == '21'
      #     print '.'
      #   end
      #   break if printed==2
      #   puts
      # end

      from = map.find {|l| l.label=='1'}.coords
      to = map.find {|l| l.label=='17'}.coords
      puts "From #{from} to #{to}"
      x = Day11.path_between(map, from, to)
      expect(x).to be 28
    end

    it 'can do my real one' do
      map = Day11.make_map(Day11.parse(read_file_and_chomp('silver.txt')))

      set = Day11.path_set(map)
      puts "we have #{set.length} paths to make"
      lengths = set.map do |labels|
        from_label, to_label = labels.map(&:to_s)
        from = map.find {|l| l.label == from_label }
        to = map.find {|l| l.label == to_label }
        Day11.path_between(map, from.coords, to.coords)
      end
      expect(lengths.inject(:+)).to eq 10231178
    end
  end
end
