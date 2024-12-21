require_relative 'main.rb'

describe 'AOC' do
  before do
    @raw = """
    """
    @example = read_file_and_chomp('example.txt')
    @ex2 = read_file_and_chomp('ex2.txt')
    @ex3 = read_file_and_chomp('ex3.txt')
    @silver = read_file_and_chomp('silver.txt')
  end

  describe 'silver' do
    describe 'examples' do
      it 'can do it' do
        x = AOC.silver(@example)
        expect(x).to eq nil
      end
    end

    describe 'for real' do
      it 'can do it' do
        $debug = false
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
        $debug = false
        x = AOC.gold(@silver)
        expect(x).to eq nil
      end
    end
  end
end
