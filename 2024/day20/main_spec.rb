require_relative 'main.rb'

describe 'AOC' do
  before do
    @raw = """
    """
    @example = read_file_to_array_of_single_char('example.txt')
    @silver = read_file_to_array_of_single_char('silver.txt')
  end

  describe 'silver' do
    describe 'examples' do
      it 'can do it' do
        $debug = true
        x = AOC.silver(@example)
        expect(x).to eq 84
      end
    end

    describe 'for real' do
      it 'can do it' do
        x = AOC.silver(@silver)
        expect(x).to be > 1242
        expect(x).to eq 1263
      end
    end
  end

  describe 'gold' do
    describe 'examples' do
      it 'can do it' do
        $debug=true
        x = AOC.gold(@example)
        expect(x).to eq nil
      end
    end

    describe 'for real' do
      it 'can do it' do
        x = AOC.gold(@silver)
        expect(x).to be > 9325
        expect(x).to eq nil
      end
    end
  end
end
