# frozen_string_literal: true

require 'pp'
require 'optparse'
require 'digest'

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

def mine(prefix, target_length)
  md5 = Digest::MD5.new
  hash_head = ''
  counter = 0
  until hash_head == ''.rjust(target_length, '0')
    md5.reset
    counter += 1
    md5 << prefix
    md5 << counter.to_s
    hash_head = md5.hexdigest.slice(0, target_length)
    puts "#{counter} => #{hash_head}" if $args[:verbose]
  end
  counter
end

prefix = slurp($args[:file]).first
puts mine(prefix, 6)
