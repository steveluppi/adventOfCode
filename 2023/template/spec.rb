require_relative 'main.rb'

describe 'AOC' do
  before do
    @raw = """
    """
    @example = read_file_and_chomp('example.txt')
    @silver = read_file_and_chomp('silver.txt')
  end

  describe 'parse' do
    it 'does the thing' do
      x = AOC.parse(@raw.split)
    end
  end
end
