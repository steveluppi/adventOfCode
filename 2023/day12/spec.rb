require_relative 'main.rb'

  # ???.### 1,1,3 - 1 arrangement
  # .??..??...?##. 1,1,3 - 4 arrangements
  # ?#?#?#?#?#?#?#? 1,3,1,6 - 1 arrangement
  # ????.#...#... 4,1,1 - 1 arrangement
  # ????.######..#####. 1,6,5 - 4 arrangements
  # ?###???????? 3,2,1 - 10 arrangements

describe 'AOC' do
  before do
    @raw = """
    """
    @example = read_file_and_chomp('example.txt')
    @silver = read_file_and_chomp('silver.txt')
  end

  describe 'silver' do 
    it 'for the example' do
      poss = @example.map { |l| AOC.silver l }
  
      expect(poss.inject(:+)).to eq 21
    end

    it 'for real' do
      poss = @silver.map { |l| AOC.silver l }

      expect(poss.inject(:+)).to eq 7007
    end
  end

  describe 'gold' do 
    describe 'examples' do
      it 'does the first one' do 
        poss = AOC.gold '???.### 1,1,3'
        expect(poss).to eq 1
      end
      it 'does the second one' do 
        poss = AOC.gold '.??..??...?##. 1,1,3'
        expect(poss).to eq 16384
      end
      it 'does the second one' do 
        poss = AOC.gold '?#?#?#?#?#?#?#? 1,3,1,6'
        expect(poss).to eq 1
      end
      it 'does the second one' do 
        poss = AOC.gold '????.#...#... 4,1,1'
        expect(poss).to eq 16
      end
      it 'does the second one' do 
        poss = AOC.gold '????.######..#####. 1,6,5'
        expect(poss).to eq 2500
      end
      it 'does the second one' do 
        poss = AOC.gold '?###???????? 3,2,1'
        expect(poss).to eq 506250
      end
    end

    it 'for the example' do
      poss = @example.map { |l| AOC.gold l }
  
      expect(poss.inject(:+)).to eq 525152
    end

    xit 'for real' do
      poss = @silver.map { |l| AOC.build_it_myself l }
      # poss = AOC.build_it_myself@example[0]
  

      expect(poss.inject(:+)).to eq 100
    end
  end
end
