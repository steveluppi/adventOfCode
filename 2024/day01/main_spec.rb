require_relative 'main.rb'

describe 'AOC' do
  before do
    @raw = """
3   4
4   3
2   5
1   3
3   9
3   3
    """
    @example = read_file_and_chomp('example.txt')
    @silver = read_file_and_chomp('silver.txt')
  end

  describe 'silver' do
    describe 'examples' do
      it 'can do it raw' do
        x = AOC.silver(@raw)
        expect(x).to eq 11
      end

      it 'can do it' do
        x = AOC.silver(@example)
        expect(x).to eq 11
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
        expect(x).to eq 31
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
