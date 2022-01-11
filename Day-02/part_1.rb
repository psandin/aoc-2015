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

def surface_area(pkg)
  sizes = [pkg[0] * pkg[1], pkg[2] * pkg[1], pkg[0] * pkg[2]]
  (2 * sizes.sum) + sizes.min
end

raw_lines = slurp($args[:file])
puts raw_lines.to_s
pkgs = parse_inputs(raw_lines)
areas = pkgs.map { |p| surface_area(p) }
puts areas
puts
puts areas.sum
