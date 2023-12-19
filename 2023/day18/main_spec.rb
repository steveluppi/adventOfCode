require_relative 'main.rb'

describe 'AOC' do
  before do
    @raw = """
    """
    @example = read_file_and_chomp('example.txt')
    @silver = read_file_and_chomp('silver.txt')
  end

  describe 'silver' do
    describe 'examples' do
      it 'can do it' do
        x = AOC.silver(@example)
        expect(x).to eq 62
      end
      it 'can do it with boxes' do
        x = AOC.silver_boxes(@silver)
        expect(x).to eq 62
      end
    end

    describe 'for real' do
      it 'can do it' do
        x = AOC.silver(@silver)
        expect(x).to eq 53844
      end
    end
  end

  describe 'gold' do
    describe 'examples' do
      it 'can do it' do
        x = AOC.gold(@example)
        expect(x).to eq 952408144115
      end
    end

    describe 'for real' do
      it 'can do it' do
        x = AOC.gold(@silver)
        expect(x).to eq 42708339569950
      end
    end
  end
end
