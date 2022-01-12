# frozen_string_literal: true

require 'pp'
require 'optparse'

# Adding number? to string
class String
  def number?
    to_i.to_s == self
  end
end

$args = {
  file: "#{File.dirname(__FILE__)}/input"
}
OptionParser.new do |opts|
  opts.on('-s', '--simple') do
    $args[:file] = "#{File.dirname(__FILE__)}/input.simple"
  end
  opts.on('-f PATH', '--file PATH', String) do |path|
    $args[:file] = path
  end
  opts.on('-v', '--verbose') do
    $args[:verbose] = true
  end
end.parse!

def slurp(path)
  input_fh = File.open(path)
  input_str = input_fh.read
  input_fh.close

  input_str.split(/\n/)
end

def parse_input(lines)
  lines.each_with_index.map do |l, i|
    r = {}
    raw_args, r[:target] = l.split(/ -> /)
    r[:line] = i + 1
    split_args = raw_args.split(/ /)
    case split_args.count
    when 1
      if split_args[0].number?
        r[:op] = :LITERAL
        r[:value] = split_args[0].to_i
        r[:available] = true
      else
        r[:op] = :COPY
        r[:source] = split_args[0]
        r[:available] = false
      end
    when 2
      r[:op] = :NOT
      r[:source] = split_args[1]
      r[:available] = false
    when 3
      r[:op] = split_args[1].to_sym
      r[:source] = [split_args[0], split_args[2]]
      r[:available] = false
    end
    [r[:target], r]
  end.to_h
end

def evaluate(wires)
  until fill_wires(wires).zero?; end
end

def display_wires(wires)
  wires.each do |k, v|
    if v[:available]
      puts "#{k} => #{v[:value]}"
    else
      puts "#{k} => #{v[:op]} | #{v[:source]}"
    end
  end
end

def get_sources(sources, wires)
  sources.map do |e|
    if e.number?
      {
        available: true,
        op: :literal,
        value: e.to_i,
      }
    else
      wires[e]
    end
  end
end

def fill_wires(wires)
  updates = 0
  wires.each do |_, v|
    next if v[:available]

    case v[:op]
    when :NOT
      s = wires[v[:source]]
      if s[:available]
        updates += 1
        v[:available] = true
        v[:value] = (s[:value]).to_s(2).rjust(16, '0').chars.map do |c|
          c == '1' ? '0' : '1'
        end.join.to_i(2)
      end
    when :COPY
      s = wires[v[:source]]
      if s[:available]
        updates += 1
        v[:available] = true
        v[:value] = s[:value]
      end
    when :RSHIFT
      s = wires[v[:source][0]]
      if s[:available]
        updates += 1
        v[:available] = true
        v[:value] = s[:value] >> v[:source][1].to_i
      end
    when :LSHIFT
      s = wires[v[:source][0]]
      if s[:available]
        updates += 1
        v[:available] = true
        v[:value] = s[:value] << v[:source][1].to_i
      end
    when :AND
      s = get_sources(v[:source], wires)
      if s.all? { |s| s[:available]}
        updates += 1
        v[:available] = true
        v[:value] = s[0][:value] & s[1][:value]
      end
    when :OR
      s = get_sources(v[:source], wires)
      if s.all? { |s| s[:available]}
        updates += 1
        v[:available] = true
        v[:value] = s[0][:value] | s[1][:value]
      end
    end
  end
  updates
end

raw_lines = slurp($args[:file])
wires = parse_input(raw_lines)
evaluate(wires)
display_wires(wires)
puts wires['a'][:value]
