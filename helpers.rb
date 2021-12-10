def read_file_and_chomp(file_path)
  File.readlines(file_path).map { |line| line.chomp }
end

def read_file_to_array(file_path)
  File.readlines(file_path).map(&:chomp).first.split(',').map(&:to_i)
end

def read_file_to_array_of_single_char(file_path)
  File.readlines(file_path).map(&:chomp).map{|x| x.split('')}
end

def array_to_i(input)
  input.map { |i| i.to_i }
end

class String
  def red;            "\e[31m#{self}\e[0m" end
end
