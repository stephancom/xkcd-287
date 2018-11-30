#!/usr/bin/env ruby

#       by stephan.com    _
#   _____  _____  _ __ __| |
#  / _ \ \/ / _ \| '__/ _` |
# |  __/>  < (_) | | | (_| |
#  \___/_/\_\___/|_|  \__,_|

# exord - for exact orders
# based on XKCD 287 - https://xkcd.com/287/
# in fulfillment of a programming challenge

require 'pry'
require 'monetize'
require 'terminal-table'
require './lib/item'
include Exord

Money.locale_backend = :currency

infile = ARGV.shift

total = 0
items = []
File.open(infile) do |f|
  total = Monetize.parse(f.readline)
  f.each do |thisline|
    items << Item.new(*thisline.chomp.split(','))
  end
end

puts Terminal::Table.new title: 'Menu',
                         headings: %w[Item Cost],
                         rows: items.sort.map(&:to_row)
puts "Desired total: $#{total}"

# pry
