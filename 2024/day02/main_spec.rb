require_relative 'main.rb'

describe 'AOC' do
  before do
    @raw = """
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
8 6 4 5 1
1 3 6 7 9
    """
    @example = read_file_and_chomp('example.txt')
    @silver = read_file_and_chomp('silver.txt')
  end

  describe 'silver' do
    describe 'examples' do
      it 'can do it raw' do
        x = AOC
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
    it 'can do a specific line' do
      expect(AOC.gold(['50 49 50 51 52 54 55'])).to eq true
    end
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
      it 'can do it for Lee' do
        x = AOC.gold(read_file_and_chomp('lee.txt'))
        expect(x).to eq nil
      end
    end
  end
end
