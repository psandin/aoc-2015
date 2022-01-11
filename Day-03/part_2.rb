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

def walk(path)
  puts path
  current = { a: [0, 0], b: [0, 0] }
  visited = { current[:a].clone => true }
  path.chars.each_slice(2) do |a, b|
    case a
    when '>'
      current[:a][0] += 1
    when '<'
      current[:a][0] -= 1
    when 'v'
      current[:a][1] += 1
    when '^'
      current[:a][1] -= 1
    end
    visited[current[:a].clone] = true
    case b
    when '>'
      current[:b][0] += 1
    when '<'
      current[:b][0] -= 1
    when 'v'
      current[:b][1] += 1
    when '^'
      current[:b][1] -= 1
    end
    visited[current[:b].clone] = true
  end
  puts visited.keys.map(&:to_s)
  visited.keys.count
end

raw_lines = slurp($args[:file])
raw_lines.each_with_index do |e, i|
  puts "#{i + 1}: #{walk(e)}"
end
