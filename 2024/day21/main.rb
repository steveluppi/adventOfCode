require_relative '../../helpers'
require 'io/console'
require 'set'

class NumPad
  MOVES = {
    'A' => {
      'A' => '',
      '0' => '<',
      '1' => '^<< <<^',
      '2' => '^< <^',
      '3' => '^',
      '4' => '^^<< <<^^',
      '5' => '^^< <^^',
      '6' => '^^',
      '7' => '^^^<< <<^^^',
      '8' => '^^^< ^^^<',
      '9' => '^^^',
    },
    '0' => {
      'A' => '>',
      '0' => '',
      '1' => '^< <^',
      '2' => '^',
      '3' => '^> >^',
      '4' => '^^< <^^',
      '5' => '^^',
      '6' => '^^> >^^',
      '7' => '^^^< <^^^',
      '8' => '^^^',
      '9' => '^^^> >^^^',
    },
    '1' => {
      'A' => '>>v v>>',
      '0' => '>v v>',
      '1' => '',
      '2' => '>',
      '3' => '>>',
      '4' => '^',
      '5' => '^> >^',
      '6' => '^>> >>^',
      '7' => '^^',
      '8' => '^^> >^^',
      '9' => '^^>> >>^^',
    },
    '2' => {
      'A' => 'v> >^',
      '0' => 'v',
      '1' => '<',
      '2' => '',
      '3' => '>',
      '4' => '^< <^',
      '5' => '^',
      '6' => '^> >^',
      '7' => '^^< <^^',
      '8' => '^^',
      '9' => '^^> >^^',
    },
    '3' => {
      'A' => 'v',
      '0' => 'v< <v',
      '1' => '<<',
      '2' => '<',
      '3' => '',
      '4' => '^<< <<^',
      '5' => '^< <^',
      '6' => '^',
      '7' => '^^<< <<^^',
      '8' => '^^< <^^',
      '9' => '^^',
    },
    '4' => {
      'A' => '>>vv vv>>',
      '0' => '>vv vv>',
      '1' => 'v',
      '2' => '>v v>',
      '3' => '>>v v>>',
      '4' => '',
      '5' => '>',
      '6' => '>>',
      '7' => '^',
      '8' => '^> >^',
      '9' => '^>> >>^',
    },
    '5' => {
      'A' => 'vv> >vv',
      '0' => 'vv',
      '1' => 'v< <v',
      '2' => 'v',
      '3' => 'v> >v',
      '4' => '<',
      '5' => '',
      '6' => '>',
      '7' => '^< <^',
      '8' => '^',
      '9' => '^> >^',
    },
    '6' => {
      'A' => 'vv',
      '0' => 'vv< <vv',
      '1' => 'v<< <<v',
      '2' => 'v< <v',
      '3' => 'v',
      '4' => '<<',
      '5' => '<',
      '6' => '',
      '7' => '^<< <<^',
      '8' => '^< <^',
      '9' => '^',
    },
    '7' => {
      'A' => '>>vvv vvv>>',
      '0' => '>vvv vvv>',
      '1' => 'vv',
      '2' => 'vv> >vv',
      '3' => 'vv>> >>vv',
      '4' => 'v',
      '5' => 'v> >v',
      '6' => 'v>> >>v',
      '7' => '',
      '8' => '>',
      '9' => '>>',
    },
    '8' => {
      'A' => '>vvv vvv>',
      '0' => 'vvv',
      '1' => 'vv< <vv',
      '2' => 'vv',
      '3' => 'vv> >vv',
      '4' => 'v< <v',
      '5' => 'v',
      '6' => 'v> >v',
      '7' => '<',
      '8' => '',
      '9' => '>',
    },
    '9' => {
      'A' => 'vvv',
      '0' => 'vvv< <vvv',
      '1' => 'vv<< <<vv',
      '2' => 'vv< <vv',
      '3' => 'vv',
      '4' => 'v<< <<v',
      '5' => 'v< <v',
      '6' => 'v',
      '7' => '<<',
      '8' => '<',
      '9' => '',
    },
  }

  def initialize
    @pos = 'A'
  end

  def to(position)
    # path = MOVES[@pos][position]
    path = priority_moves(@pos, position).first
    @pos = position
    return path
  end

  def print_pad
    (7..9).map(&:to_s).each{|l| print @pos == l ? l.red : l}
    puts
    (4..6).map(&:to_s).each{|l| print @pos == l ? l.red : l}
    puts
    (1..3).map(&:to_s).each{|l| print @pos == l ? l.red : l}
    puts
    print ' ' 
    print @pos == '0' ? "0".red : "0"
    print @pos == 'A' ? "A".red : "A"
    puts
    puts
  end

  def priority_moves(from, to)
    moves = MOVES[from][to].split(' ')
    # return moves
    moves.sort! do |a,b| 
      case 
      when a.start_with?(from)
        -1
      when b.start_with?(from)
        1
      else
        0
      end
    end
    moves
  end
end

class DPad
  MOVES = {
    'A' => {
      'A' => '',
      '^' => '<',
      '<' => 'v<< <<v',
      'v' => 'v< <v',
      '>' => 'v'
    },
    '^' => {
      'A' => '>',
      '^' => '',
      '<' => 'v< <v',
      'v' => 'v',
      '>' => 'v> >v'
    },
    '<' => {
      'A' => '>>^ ^>>',
      '^' => '>^ ^>',
      '<' => '',
      'v' => '>',
      '>' => '>>'
    },
    'v' => {
      'A' => '>^ ^>',
      '^' => '^',
      '<' => '<',
      'v' => '',
      '>' => '>'
    },
    '>' => {
      'A' => '^',
      '^' => '^< <^',
      '<' => '<<',
      'v' => '<',
      '>' => ''
    },
  }
  def initialize
    @pos = 'A'
  end

  def to(position)
    # path = MOVES[@pos][position]
    return '' if position==@pos
    path = priority_moves(@pos, position).first
    @pos = position
    return path
  end

  def print_pad
    puts
    print ' '
    print @pos == '^' ? '^'.red : '^'
    print @pos == 'A' ? 'A'.red : 'A'
    puts
    print @pos == '<' ? '<'.red : '<'
    print @pos == 'v' ? 'v'.red : 'v'
    print @pos == '>' ? '>'.red : '>'
    puts
    puts
  end
  def priority_moves(from, to)
    moves = MOVES[from][to].split(' ')
    # return moves
    moves.sort! do |a,b| 
      case 
      when a.start_with?(from)
        -1
      when b.start_with?(from)
        1
      else
        0
      end
    end
    moves
  end
end

class AOC
  def self.silver(lines)
    num_pad = NumPad.new
    dpad1 = DPad.new
    dpad2 = DPad.new

    complexities = lines.map do |code|
      dpad1_path = AOC.dpad1_path(code, num_pad)

      dpad2_path = AOC.dpad2_path(dpad1_path, dpad1)

      dpad3_path = AOC.dpad3_path(dpad2_path, dpad2)

      path_len = dpad3_path.length
      code_val = code.gsub('A','').to_i
      complexity = path_len * code_val

      puts
      puts "#{code}: #{dpad3_path}".blue
      puts "#{code}: #{path_len} * #{code_val} = #{complexity}"
      complexity
      # dpad3_path
    end

    complexities.sum
  end

  def self.dpad1_path(code, num_pad)
    dpad1_path = ''
    code.split('').each do |key|
      path = num_pad.to(key)
      dpad1_path << path << 'A'
    end
    dpad1_path
  end

  def self.dpad2_path(dpad1_path, dpad1)
    dpad2_path = ''
    dpad1_path.split('').each do |key|
      path = dpad1.to(key)
      dpad2_path << path << 'A'
    end
    dpad2_path 
  end
  def self.dpad3_path(dpad2_path, dpad2)
    dpad3_path = ''
    dpad2_path.split('').each do |key|
      path = dpad2.to(key)
      dpad3_path << path << 'A'
    end
    dpad3_path 
  end

  def self.gold(lines)
  end
end
