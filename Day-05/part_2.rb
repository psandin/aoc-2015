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

def nice?(string)
  double_pair?(string) && spaced_pair?(string)
end

def double_pair?(string)
  (0..string.length - 3).each do |i|
    target_str = string.slice(i, 2)
    (i + 2..string.length - 1).each do |j|
      return true if target_str == string.slice(j, 2)
    end
  end
  false
end

def spaced_pair?(string)
  (0..string.length - 2).each do |i|
    triple = string.slice(i, 3).chars
    return true if triple[0] == triple[2]
  end
  false
end

raw_lines = slurp($args[:file])
puts raw_lines.select { |e| nice?(e) }.count
