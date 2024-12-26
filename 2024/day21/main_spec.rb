require_relative 'main.rb'

describe 'AOC' do
  before do
    @raw2 = """
3
A
37
A
379A
"""
    @raw = """
029A
980A
179A
456A
379A
"""
    @example = read_file_and_chomp('example.txt')
    @silver = read_file_and_chomp('silver.txt')
  end

  describe 'finding the best path' do
    it 'can sort stuff' do
      np = NumPad.new
      p np.priority_moves('A', 'A')
    end
  end
  describe 'silver' do
    describe 'examples' do
      it 'can do it raw' do
        x = AOC.silver(@raw.split().map(&:chomp))
        # expect(x).to eq "<v<A>>^AvA^A<vA<AA>>^AAvA<^A>AAvA^A<vA>^AA<A>A<v<A>A>^AAAvA<^A>A"
        expect(x).to eq 126384
      end
      it 'can do it' do
        x = AOC.silver(@example)
        expect(x).to eq nil
      end
    end

    describe 'for real' do
      it 'can do it' do
        x = AOC.silver(@silver)
        expect(x).to eq nil
      end
    end
  end

  describe 'gold' do
    describe 'examples' do
      it 'can do it' do
        x = AOC.gold(@example)
        expect(x).to eq nil
      end
    end

    describe 'for real' do
      it 'can do it' do
        x = AOC.gold(@silver)
        expect(x).to eq nil
      end
    end
  end
end
