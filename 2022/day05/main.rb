# Advent of Code - Day 5
require_relative "../helpers"

def silver(input)
  stacks=input.select{|i| /\[/.match?(i)}
  steps=input.select{|i| /move/.match?(i)}

  stacks.map! { |i| 
    row=[]
    for j in (1..i.length).step(4)
      row.push(i[j])
    end
    row
  }

  stacks = stacks.transpose.map!{|i|i.reverse!}.map!{|i| i.select{|j| j!=" "}}

  steps.map!{|i| /(\d+).+(\d+).+(\d+)/m.match(i).captures }

  steps.each do |s| 
    s.map!(&:to_i)

    num = s[0]
    from = s[1]-1
    to = s[2]-1
    
    (num.to_i).times do |x|
      stacks[to].push(stacks[from].pop())
    end
  end

  stacks.map(&:last).join
end

def gold(input)
  stacks=input.select{|i| /\[/.match?(i)}
  steps=input.select{|i| /move/.match?(i)}

  stacks.map! { |i| 
    row=[]
    for j in (1..i.length).step(4)
      p i[j]
      row.push(i[j])
    end
    row
  }

  stacks = stacks.transpose.map!{|i|i.reverse!}.map!{|i| i.select{|j| j!=" "}}

  steps.map!{|i| /(\d+).+(\d+).+(\d+)/m.match(i).captures }

  steps.each do |s| 
    s.map!(&:to_i)

    num = s[0]
    from = s[1]-1
    to = s[2]-1
    
    stacks[to].push(stacks[from].pop(num)).flatten!
  end

  stacks.map(&:last).join
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
puts "Gold: #{gold(@input)}"
