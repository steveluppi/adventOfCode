require_relative 'main.rb'

describe 'AOC' do
  before do
    @raw = """
    """
    @example = read_file_to_array_of_single_char('example.txt')
    @example2 = read_file_to_array_of_single_char('example2.txt')
    @silver = read_file_to_array_of_single_char('silver.txt')
  end

  describe 'silver' do
    describe 'examples' do
      it 'can do it' do
        x = AOC.silver(@example)
        expect(x).to eq 7036
      end
      it 'can do it for the second' do
        x = AOC.silver(@example2)
        expect(x).to eq 11048
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
        expect(x).to eq 45
      end
      it 'can do it for the second' do
        x = AOC.gold(@example2)
        expect(x).to eq 64
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
