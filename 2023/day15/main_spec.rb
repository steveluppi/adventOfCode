require_relative 'main.rb'

describe 'AOC' do
  before do
    @raw = """
HA
SH
    """
    @example = read_file_and_chomp('example.txt')
    @silver = read_file_and_chomp('silver.txt')
  end

  describe 'silver' do
    describe 'examples' do
      it 'can do HASH' do
        x = AOC.silver(@raw.split)
        expect(x).to eq 52
      end
      it 'does one' do
        x = AOC.silver(@example)
        expect(x).to eq 1320
      end 
    end
    describe 'for real' do
      it 'can do it' do
        x = AOC.silver(@silver)
        expect(x).to eq 518107
      end
    end
  end

  describe 'gold' do
    describe 'examples' do
      it 'can do the example' do
        x = AOC.gold(@example)
        expect(x).to eq 145
      end
    end
    describe 'for real' do
      it 'can do it' do
        x = AOC.gold(@silver)
        expect(x).to eq 303404
      end
    end
  end
end
