# Advent of Code - Day 8
require_relative "../helpers"

def parseInput(file_path)
  File.readlines(file_path).map(&:chomp).map!{|l| l.split('').map(&:to_i)}
end

def silver(input)
  visible_count=0
  input.each_with_index do |row, row_index|
    row.each_with_index do |col, col_index|
      if col_index==0 or row_index==0 or row_index==input.length-1 or col_index==row.length-1
        visible_count+=1
        next
      end
      puts "#{input[row_index][col_index]} is at #{row_index},#{col_index}"
      # Do the check for up
      up_vis = true
      for r in 0..row_index-1
        # puts "Checking row #{r}"
        # puts "\tchecking up at #{r},#{col_index} => #{input[r][col_index]} to #{col}"
        up_vis = false if input[r][col_index] >= col
      end
      
      # Do the check for left
      left_vis = true
      for c in 0..col_index-1
        # puts "Checking row #{r}"
        # puts "\tchecking left at #{row_index},#{c} => #{input[row_index][c]} to #{col}"
        left_vis = false if input[row_index][c] >= col
      end

      # Do the check for right
      right_vis = true
      for c in col_index+1..row.length-1
        # puts "Checking row #{r}"
        # puts "\tchecking right at #{row_index},#{c} => #{input[row_index][c]} to #{col}"
        right_vis = false if input[row_index][c] >= col
      end

      # Do the check for down
      down_vis = true
      for r in row_index+1..row.length-1
        # puts "Checking row #{r}"
        # puts "\tchecking down at #{r},#{col_index} => #{input[r][col_index]} to #{col}"
        down_vis = false if input[r][col_index] >= col
      end
      p up_vis,down_vis,left_vis,right_vis
      visible_count+=1 if (up_vis | left_vis | right_vis | down_vis) == true
      puts " Visible" if (up_vis | left_vis | right_vis | down_vis) == true
    end
  end

  visible_count
end

def gold(input)
  max=0
  input.each_with_index do |row, row_index|
    row.each_with_index do |col, col_index|
      # if col_index==0 or row_index==0 or row_index==input.length-1 or col_index==row.length-1
      #   visible_count+=1
      #   next
      # end
      puts "#{input[row_index][col_index]} is at #{row_index},#{col_index}"
      # Do the check for up
      up_vis = 0
      for r in (row_index-1..0).step(-1)
        # puts "Checking row #{r}"
        puts "\tchecking up at #{r},#{col_index} => #{input[r][col_index]} to #{col}"
        up_vis += 1 #if input[r][col_index] <= col
        break if input[r][col_index] >= col
      end
      
      # Do the check for left
      left_vis = 0
      for c in (col_index-1..0).step(-1)
        # puts "Checking row #{r}"
        puts "\tchecking left at #{row_index},#{c} => #{input[row_index][c]} to #{col}"
        left_vis += 1 #if input[row_index][c] <= col
        break if input[row_index][c] >= col
      end

      # Do the check for right
      right_vis = 0
      for c in col_index+1..row.length-1
        # puts "Checking row #{r}"
        puts "\tchecking right at #{row_index},#{c} => #{input[row_index][c]} to #{col}"
        right_vis += 1 #if input[row_index][c] <= col
        break if input[row_index][c] >= col
      end

      # Do the check for down
      down_vis = 0
      for r in row_index+1..row.length-1
        # puts "Checking row #{r}"
        puts "\tchecking down at #{r},#{col_index} => #{input[r][col_index]} to #{col}"
        down_vis += 1# if input[r][col_index] <= col
        break if input[r][col_index] >= col
      end
      p up_vis,left_vis,down_vis,right_vis
      curr= up_vis*down_vis*left_vis*right_vis
      max=curr if curr>max

      # visible_count+=1 if (up_vis | left_vis | right_vis | down_vis) == true
      # puts " Visible" if (up_vis | left_vis | right_vis | down_vis) == true
    end
  end
  max
end


# Main execution
@input = parseInput(
  case ARGV[0]
  when "silver"
    "silver.txt"
  when "gold"
    "gold.txt"
  else
    "example.txt"
  end
)

# puts "Silver: #{silver(@input)}"
puts "Gold: #{gold(@input)}"
