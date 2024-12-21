require_relative 'main.rb'

describe 'AOC' do
  before do
    @raw = """
    """
    @small = read_file_and_chomp('small.txt')
    @inner = read_file_and_chomp('inner.txt')
    @abba = read_file_and_chomp('abba.txt')
    @eee = read_file_and_chomp('eee.txt')
    @example = read_file_and_chomp('example.txt')
    @silver = read_file_and_chomp('silver.txt')
  end

  describe 'silver' do
    describe 'examples' do
      it 'can do it small' do
        x = AOC.silver(@small)
        expect(x).to eq 140
      end
      it 'can do it inner' do
        x = AOC.silver(@inner)
        expect(x).to eq 772
      end
      it 'can do it' do
        x = AOC.silver(@example)
        expect(x).to eq 1930
      end
    end

    describe 'for real' do
      it 'can do it' do
        x = AOC.silver(@silver)
        expect(x).to eq 1465112
      end
    end
  end

  describe 'gold' do
    describe 'examples' do
      it 'can do it small' do
        x = AOC.gold(@small)
        expect(x).to eq 80
      end
      it 'can do it inner' do
        x = AOC.gold(@inner)
        expect(x).to eq 436
      end
      it 'can do it eee' do
        x = AOC.gold(@eee)
        expect(x).to eq 236
      end
      it 'can do it abba' do
        x = AOC.gold(@abba)
        expect(x).to eq 368
      end
      it 'can do it' do
        x = AOC.gold(@example)
        expect(x).to eq 1206
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
