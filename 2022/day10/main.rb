# Advent of Code - Day x
require_relative "../helpers"

def print_sprite(x)
  print "Sprite Position: "
  for i in 0..40
    print '#' if (i-1..i+1).include?(x)
    print '.' unless (i-1..i+1).include?(x)
  end
  puts
end

def print_crt(crt)
  print "Current CRT row: "
  crt.each_with_index do |i,idx|
    puts if idx%40==0
    print i
  end
  puts
end

def silver(input)
  # for i in input
  #   puts i
  # end
  cycle=1
  idx=0
  x=1
  op=nil
  cycles=[]
  strength=[]
  crt=[]
  print_sprite(x)
  loop do
    break if idx>=input.length
    puts
    puts "Start cycle #{cycle}:" 
    m = /(\w+){1} ?([\-\d]+){0,1}/.match(input[idx])
    instruction = m[1]
    value = m[2]
    # p instruction,value
    # puts "Cycle start #{cycle}"

    # if cycle==20 or ((cycle-20) % 40 == 0 and cycle>10)
    #   puts "consider this cycle #{cycle}"
    #   cycles.push(cycle)
    #   strength.push(cycle*x)
    # end

    puts "#{x-1..x+1} include? #{cycle}"
    if (x-1..x+1).include?((cycle-1)%40)
      puts "During cycle #{cycle}: CRT Draws pixel at position #{crt.length}"
      crt.push('#')
    else 
      crt.push(' ')
    end
    print_sprite(x)
    print_crt(crt)


    case instruction
    when "noop"
      puts "    Handle noop by doing nothing but inrement"
      idx+=1
    when "addx"
      if op.nil?
       puts " begin executing #{instruction} #{value}"
        op=value
        # puts "    Need to increment cycle now"
      else
        puts "    Found op to have val #{op}...update memory"
        x += op.to_i
        puts " reg is now #{x}"
        puts "    now clear out op and increment instruction pointer"
        op=nil
        idx+=1
      end
    end

    puts "ending cycle #{cycle}. Increment"
    cycle+=1
  end

  puts
  p cycle
  p idx
  p x
  p op
  p cycles
  p strength
  p strength.reduce(&:+)
  puts
  "done"
end

def gold(input)
  for i in input
    puts i
  end

  "done"
end


# Main execution
@input = read_file_and_chomp(
  case ARGV[0]
  when "silver"
    "silver.txt"
  when "gold"
    "gold.txt"
  else
    "example.txt"
  end
)

puts "Silver: #{silver(@input)}"
# puts "Gold: #{gold(@input)}"
