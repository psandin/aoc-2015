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
  lines.map do |l|
    %i[raw op xmin ymin xmax ymax].zip(l.match(/(.*) (\d+),(\d+) through (\d+),(\d+)/).to_a).to_h
  end
end

def execute_instructions(ops)
  bulbs = Hash.new(0)
  ops.each do |op|
    (op[:xmin]..op[:xmax]).each do |x|
      (op[:ymin]..op[:ymax]).each do |y|
        case op[:op]
        when 'turn on'
          bulbs[[x, y]] += 1
        when 'toggle'
          bulbs[[x, y]] += 2
        when 'turn off'
          bulbs[[x, y]] -= 1
          bulbs[[x, y]] = 0 if bulbs[[x, y]].negative?
        end
      end
    end
  end
  bulbs
end

def count_bulbs(bulbs)
  bulbs.values.sum
end

raw_lines = slurp($args[:file])
puts raw_lines.to_s
ops = parse_inputs(raw_lines)
bulbs = execute_instructions(ops)
puts bulbs
puts count_bulbs(bulbs)
