require_relative 'main.rb'

describe 'AOC' do
  before do
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

  describe 'silver' do
    describe 'examples' do
      it 'can do it raw' do
        x = AOC.silver(@raw.split().map(&:chomp))
        expect(x).to eq nil
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
