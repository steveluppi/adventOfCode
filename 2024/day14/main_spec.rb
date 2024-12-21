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
        expect(x).to eq nil
      end
    end

    describe 'for real' do
      it 'can do it' do
        x = AOC.silver(@silver)
        expect(x).to be > 71840088
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

  describe 'is sym' do
    it 'can test sym' do
      $mx = 5
      $my = 3
      $bots = []
      # $bots << Robot.new(0,0,0,0)

      $bots << Robot.new(2,0,0,0)

      # $bots << Robot.new(1,1,0,0)
      # $bots << Robot.new(2,1,0,0)
      # $bots << Robot.new(3,1,0,0)
      #
      # $bots << Robot.new(0,2,0,0)
      # $bots << Robot.new(1,2,0,0)
      # $bots << Robot.new(2,2,0,0)
      # $bots << Robot.new(3,2,0,0)
      # $bots << Robot.new(4,2,0,0)

      AOC.print_grid
      expect(AOC.has_tree?).to be true
    end
  end
end
