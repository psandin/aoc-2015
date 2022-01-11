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
  !bad_substring(string) && good_vowel_count(string) && double_letter?(string)
end

def good_vowel_count(string)
  vowels = %w[a e i o u]
  string.chars.select { |e| vowels.any? { |v| v == e } }.count > 2
end

def double_letter?(string)
  (0..string.length - 1).each do |i|
    return true if string.slice(i, 2).chars.reduce(:==) == true
  end
  false
end

def bad_substring(string)
  return true if string.include? 'ab'
  return true if string.include? 'cd'
  return true if string.include? 'pq'
  return true if string.include? 'xy'

  false
end

raw_lines = slurp($args[:file])
puts raw_lines.select { |e| nice?(e) }.count
