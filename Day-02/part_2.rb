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

def parse_inputs(lines)
  lines.map { |l| l.split(/x/).map(&:to_i) }
end

def ribbon_needed(pkg)
  (pkg.sort.slice(0, 2).sum * 2) + pkg.reduce(:*)
end

raw_lines = slurp($args[:file])
puts raw_lines.to_s
pkgs = parse_inputs(raw_lines)
areas = pkgs.map { |p| ribbon_needed(p) }
puts areas
puts
puts areas.sum
