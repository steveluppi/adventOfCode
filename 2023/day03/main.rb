# Advent of Code - Day x
require_relative '../../helpers'

class String
  def is_digit?
    true if Integer self rescue false
  end
end

def is_symbol?(input, row, col)
  # return true if input[row][col] =~ /[\*\$\#]/
  return true if input[row][col] =~ /[^\d\.]/
  false
rescue 
  return false
end

def is_gear?(input, row, col)
  # return true if input[row][col] =~ /[\*\$\#]/
  return true if input[row][col] =~ /\*/
  false
rescue 
  return false
end

def silver(input)
  sum = 0

  current_digit = []
  are_scanning_digit = false
  digit_counts = false


  # Go over each row, determine if you are part of a digit
  # and if that digit counts
  # When it is no longer a digit, if it counts, add it to 
  # the sum
  input.each_with_index do |row, row_index|
    row.each_with_index do |column, col_index|
      # puts 
      # puts "Iteration at #{row_index}, #{col_index}"
      # puts "  with digit #{column}"
      # puts "  and vars"
      # puts "    current_digit #{current_digit}"
      # puts "    are_scanning_digit #{are_scanning_digit}"
      # puts "    digit_counts #{digit_counts}"
      # puts 

      position_is_digit = column.is_digit?

      # we _had_ a number, but we no longer do...
      # sum if it counts, otherwise clear it all out
      if are_scanning_digit && !position_is_digit
        puts "digit found: #{current_digit.join().to_i}"
        sum += current_digit.join().to_i if digit_counts
        puts " ... and was added" if digit_counts
        digit_counts = false
        current_digit.clear
        are_scanning_digit = false
        next #maybe?
      end

      # when it is a digit, we need to add it to the current digit,
      # and see if it has any adjacent fields that count
      if position_is_digit
        current_digit << column
        are_scanning_digit = true

        # check all adjacent spots
        # Start with the row above
        checks = [is_symbol?(input, row_index-1, col_index-1),
                  is_symbol?(input, row_index-1, col_index),
                  is_symbol?(input, row_index-1, col_index+1)]
        # Address the current row
        checks << [is_symbol?(input, row_index, col_index-1),
                   is_symbol?(input, row_index, col_index+1)]
        # and the Row Below
        checks << [is_symbol?(input, row_index+1, col_index-1),
                   is_symbol?(input, row_index+1, col_index),
                   is_symbol?(input, row_index+1, col_index+1)]
        checks.flatten!
        overall = checks.compact.any?{|x| x}
        digit_counts = overall if overall
      end
    end
  end

  sum
end

def gold(input)
  sum = 0
  gear_ratio = {}

  current_digit = []
  are_scanning_digit = false
  digit_counts = false
  digit_counts_because = []


  # Go over each row, determine if you are part of a digit
  # and if that digit counts
  # When it is no longer a digit, if it counts, add it to 
  # the sum
  input.each_with_index do |row, row_index|
    row.each_with_index do |column, col_index|
      # puts 
      # puts "Iteration at #{row_index}, #{col_index}"
      # puts "  with digit #{column}"
      # puts "  and vars"
      # puts "    current_digit #{current_digit}"
      # puts "    are_scanning_digit #{are_scanning_digit}"
      # puts "    digit_counts #{digit_counts}"
      # puts 

      position_is_digit = column.is_digit?

      # we _had_ a number, but we no longer do...
      # sum if it counts, otherwise clear it all out
      if are_scanning_digit && !position_is_digit
        puts "digit found: #{current_digit.join().to_i}"

        # store in the ratio if the digit is a gear
        gear_ratio[digit_counts_because] ||= []
        gear_ratio[digit_counts_because] << current_digit.join().to_i if digit_counts
        puts " ... and was added to ratio" if digit_counts

        # if there are now two gears, sum them up
        # if gear_ratio.length > 1
        #   puts " ... and ratio was added"
        #   sum += gear_ratio.inject(:*) 
        #   gear_ratio.clear
        # end

        digit_counts = false
        digit_counts_because = []
        current_digit.clear
        are_scanning_digit = false
        next #maybe?
      end

      # when it is a digit, we need to add it to the current digit,
      # and see if it has any adjacent fields that count
      if position_is_digit
        current_digit << column
        are_scanning_digit = true

        # check all adjacent spots
        # Start with the row above
        ul = is_gear?(input, row_index-1, col_index-1)
        digit_counts = true if ul
        digit_counts_because = [row_index-1, col_index-1] if ul
        next if ul

        uu = is_gear?(input, row_index-1, col_index)
        digit_counts = true if uu
        digit_counts_because = [row_index-1, col_index] if uu
        next if uu

        ur = is_gear?(input, row_index-1, col_index+1)
        digit_counts = true if ur
        digit_counts_because = [row_index-1, col_index+1] if ur
        next if ur

        # Address the current row
        l = is_gear?(input, row_index, col_index-1)
        digit_counts = true if l
        digit_counts_because = [row_index, col_index-1] if l
        next if l

        r = is_gear?(input, row_index, col_index+1)
        digit_counts = true if r
        digit_counts_because = [row_index, col_index+1] if r
        next if r

        # and the Row Below
        ll = is_gear?(input, row_index+1, col_index-1)
        digit_counts = true if ll
        digit_counts_because = [row_index+1, col_index-1] if ll
        next if ll

        lc = is_gear?(input, row_index+1, col_index)
        digit_counts = true if lc
        digit_counts_because = [row_index+1, col_index] if lc
        next if lc

        lr = is_gear?(input, row_index+1, col_index+1)
        digit_counts = true if lr
        digit_counts_because = [row_index+1, col_index+1] if lr
        next if lr
      end
    end
  end

  puts "Gear ratios at the end are"
  p gear_ratio
  gear_ratio.each {|ratio| sum += ratio[1].inject(:*) if ratio[1].length>1}
  sum
end

# Main execution
@input = read_file_to_array_of_single_char(
  case ARGV[0]
  when 'silver'
    'silver.txt'
  when 'gold'
    'gold.txt'
  else
    'example.txt'
  end
)

# puts "Silver: #{silver(@input)}"
puts "Gold: #{gold(@input)}"
