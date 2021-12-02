def read_file_and_chomp(file_path)
  File.readlines(file_path).map { |line| line.chomp }
end

def array_to_i(input)
  input.map { |i| i.to_i }
end
