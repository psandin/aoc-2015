# frozen_string_literal: true

require 'pp'
require 'optparse'

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

def parse_parens(line)
  line.chars.map { |c| c == '(' ? 1 : -1 }
end

def find_first_basement(seq)
  pos = 0
  seq.each_with_index do |e, i|
    pos += e
    return i + 1 if pos.negative?
  end
  nil
end

raw_lines = slurp($args[:file])
raw_lines.each_with_index do |l, i|
  puts "#{i + 1}: #{find_first_basement(parse_parens(l))}"
end
