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

  it 'has a field key' do
    raw = """
ANA
WXE
BSB
    """
    x = Field.new raw.split
    puts x.field_key
  end


  describe 'gold' do
    describe 'examples' do
      it 'can cycle' do
        raw = """
ANA
WXE
BSB
        """
        x = Field.new raw.split
        x.print_cycle
      end 
      it 'can do the example and be checked' do
        x = Field.new @example
        x.print_field
        3.times do
        x.cycle
        puts
        x.print_field
        end

      end
      it 'can do the example at 3' do
        x = Field.new @example
        3.times { x.cycle }
        x.print_field
        expect(l).to eq 64
      end
      it 'can do the example' do
        x = Field.new @example
        1000000000.times { x.cycle }
        l = x.load
        expect(l).to eq 64
      end
    end
    describe 'for real' do
      it 'can do it' do
        x = Field.new @silver
        1000000000.times { x.cycle }
        l = x.load
        expect(l).to eq nil
      end

      it 'goes brr with cache' do
        x = Field.new @silver

        cache = {}
        cycle = 0
        target = 1000000000
        loop do
          puts "looking at #{x.field_key}"
          if cache.has_key? x.field_key
            # This has been seen before
            seen = cache[x.field_key]
            puts "Field key found, and it was at iteration #{seen}".green
            puts "  and we are currently at #{cycle}"
            jump = cycle-seen
            puts "  and a jump would be #{jump}"
            big_jump = ((target-cycle)/jump).to_f
            puts "a big jump would be #{big_jump.floor * jump}"
            # puts "so we can do #{big_jump.floor * jump} spots ahead"
            puts "and put us at #{cycle + (big_jump.floor * jump)}"
            if cycle+big_jump < target
              cycle += (big_jump*jump)
              break
              # x.cycle
            elsif cycle+jump < target
              cycle += jump
              # x.cycle
            else
              cycle+=1
              x.cycle
            end
          else
            # This one has not been seen before.
            puts "This has not been seen, store it at #{cycle}".red
            cache[x.field_key] = cycle

            # now we need to cycle and increment
            x.cycle
            cycle += 1
          end

          # break if cycle == 1000000000
          break if cycle >= 1000000000
        end
        loop do
          puts "at second loop for #{cycle}"
          break if cycle >= 1000000000
          x.cycle
          cycle +=1
        end
        puts "ended with cycle #{cycle}"

        l = x.load
        expect(l).to eq 108404
      end
    end
  end
end
