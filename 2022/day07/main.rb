# Advent of Code - Day x
require_relative "../helpers"

def addAtPath(fs, p, k, v)
  p 'params',fs, p, k, v,'params'
  return fs[k]=v if p.length==1
  fs[p[0]] = addAtPath(fs[p[0]],p.slice(1..),k,v)
  fs
end

def formDirStruct(input)
  pwd=['/']
  fs={
    '/': {}
  }
  for line in input
    case line
    when /^\$/
      print "command"
      case line
      when /cd/
        target = /^\$\ cd\ (.+)/.match(line)[1]
        case target
        when '/'
          pwd = ['/']
        when '..'
          pwd.pop()
        else
          pwd.push(target)
        end
        puts " change dir to target #{target}"
        puts " pwd is now #{pwd}"
      when /ls/
        p "list"
      end
    when /^\d+/
      p "when file pattern"
      m = /^(\d+) (.+)/.match(line)
      size = m[1]
      name = m[2]
      puts " Found file #{name} with size #{size}"
      pwd.each_with_index do |d,idx| 
        fs[d]||={}
        fs[d][name]=size if idx == pwd.length
      end
      # fs=addAtPath(fs, pwd, name,size)
      p fs
    when /^dir/
      p "when dir pattern"
      d = /dir (.+)/.match(line)[1]
      puts " Found dir #{d}"
      # fs=addAtPath(fs, pwd, d,{})
      # p fs
    else
      p "not command"
    end
  end
  p fs
end

def silver(input)
  # for i in input
  #   puts i
  # end

  formDirStruct(input)
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
