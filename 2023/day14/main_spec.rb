require_relative 'main.rb'

describe 'AOC' do
  before do
    @raw = """
    """
    @example = read_file_and_chomp('example.txt')
    @silver = read_file_and_chomp('silver.txt')
  end

  describe 'Rock' do
    describe 'sort' do
      # ["#", "."]
      # ["#", "0"]
      # [".", "#"]
      # [".", "0"]
      # ["0", "#"]
      # ["0", "."]
      it 'can sort # and .' do
        a = Rock.new '#'
        b = Rock.new '.'
        y = [a,b]
        expect(y.sort).to eq [a,b]
      end
      it 'can sort # and O' do
        a = Rock.new '#'
        b = Rock.new 'O'
        y = [a,b]
        expect(y.sort).to eq [a,b]
      end
      it 'can sort . and #' do
        a = Rock.new '.'
        b = Rock.new '#'
        y = [a,b]
        expect(y.sort).to eq [a,b]
      end
      it 'can sort . and O' do
        a = Rock.new '.'
        b = Rock.new 'O'
        p y.sort
        expect(y.sort).to eq [b,a]
      end
      it 'can sort O and #' do
        a = Rock.new 'O'
        b = Rock.new '#'
        y = [a,b]
        expect(y.sort).to eq [a,b]
      end
      it 'can sort O and .' do
        a = Rock.new 'O'
        b = Rock.new '.'
        y = [a,b]
        expect(y.sort).to eq [a,b]
      end
    end

    it 'can sort a line of rocks' do
      row = ['OO.O.O..##']
      field = Field.new row
      field.tilt_north
      expect(field.to_s).to eq 'OOOO....##'
    end
  end

  describe 'silver' do
    describe 'examples' do
      it 'does one' do
        x = Field.new @example
        # x.print_field
        x.tilt_north
        # x.print_field
        l = x.load
        expect(l).to eq 136
      end 
    end
    describe 'for real' do
      it 'can do it' do
        x = Field.new @silver
        x.tilt_north
        l = x.load
        expect(l).to eq 108144
      end
    end
  end

  describe 'gold' do
    describe 'examples' do
      it 'does one' do
        0
      end 
    end
    describe 'for real' do
      it 'can do it' do
        0
      end
    end
  end
end
