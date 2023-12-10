def read_file_and_chomp(file_path)
  File.readlines(file_path).map(&:chomp)
end

def read_file_to_array(file_path)
  File.readlines(file_path).map(&:chomp).first.split(',').map(&:to_i)
end

def read_file_to_array_of_single_char(file_path)
  File.readlines(file_path).map(&:chomp).map { |x| x.split('') }
end

def array_to_i(input)
  input.map(&:to_i)
end

class String
  def red = "\e[31m#{self}\e[0m"
  def green = "\e[32m#{self}\e[0m"
end

def i_log(message, indent = 0)
  indent.times { |_x| print ' ' }
  puts message
end
