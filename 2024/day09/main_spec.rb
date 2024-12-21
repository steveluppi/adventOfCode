require_relative 'main.rb'

describe 'AOC' do
  before do
    @raw = """
    """
    @example = read_file_and_chomp('example.txt')
    @silver = read_file_and_chomp('silver.txt')
  end

  describe 'silver' do
    describe 'the clever way' do
      describe 'examples' do
        it 'can do it' do
          x = AOC.silver_clever(@example)
          expect(x).to eq 1928
        end
      end

      describe 'for real' do
        it 'can do it' do
          $debug=false
          x = AOC.silver_clever(@silver)
          expect(x).to be > 90542079669
          expect(x).to be < 6368660908014
          expect(x).to be < 6367087069671
          expect(x).to eq 6367087064415
        end
      end
    end
    describe 'examples' do
      it 'can do it' do
        x = AOC.silver(@example)
        expect(x).to eq 1928
      end
    end

    describe 'for real' do
      it 'can do it' do
        $debug=false
        x = AOC.silver_clever(@silver)
        expect(x).to be > 90542079669
        expect(x).to be < 6368660908014
        expect(x).to be < 6367087069671
        expect(x).to eq 6367087064415
      end
    end
  end

  describe 'gold' do
    describe 'examples' do
      it 'can do it' do
        x = AOC.gold(@example)
        expect(x).to eq 2858
      end
    end

    describe 'for real' do
      it 'can do it' do
        $debug=false
        x = AOC.gold(@silver)
        expect(x).to eq nil
      end
    end
  end
end
