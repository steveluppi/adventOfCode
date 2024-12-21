require_relative 'main.rb'

describe 'AOC' do
  before do
    @raw = """
T....#....
...T......
.T....#...
.........#
..#.......
..........
...#......
..........
....#.....
..........
    """
    @example = read_file_and_chomp('example.txt')
    @silver = read_file_and_chomp('silver.txt')
  end

  describe 'silver' do
    describe 'examples' do
      it 'can do it' do
        x = AOC.silver(@example)
        expect(x).to eq 14
      end
    end

    describe 'for real' do
      it 'can do it' do
        x = AOC.silver(@silver)
        expect(x).to eq 311
      end
    end
  end

  describe 'gold' do
    describe 'examples' do
      it 'can do it' do
        x = AOC.gold(read_file_and_chomp('example2.txt'))
        expect(x).to eq 9
      end
    end

    describe 'examples' do
      it 'can do it' do
        x = AOC.gold(@example)
        expect(x).to eq 34
      end
    end

    describe 'for real' do
      it 'can do it' do
        x = AOC.gold(@silver)
        expect(x).to eq 1115
      end
    end
  end
end
