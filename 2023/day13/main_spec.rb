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
      it 'does one' do
        x = AOC.silver @example
        expect(x).to eq 405
      end 
    end
    describe 'for real' do
      it 'can do it' do
        x = AOC.silver @silver
        expect(x).to eq 34993
      end
    end
  end

  describe 'gold' do
    describe 'examples' do
      it 'does one' do
        x = AOC.gold @example
        expect(x).to eq 400
      end 
    end
    describe 'for real' do
      it 'can do it' do
        x = AOC.gold @silver
        expect(x).to eq nil
      end
    end
  end
end
