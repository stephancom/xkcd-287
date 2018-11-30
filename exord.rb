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
require './lib/menu'
require './lib/order'
require './lib/order_entry'
include Exord

Money.locale_backend = :currency

infile = ARGV.shift

total = 0
menu = Menu.new('Exord Restaurant')
File.open(infile) do |f|
  total = Monetize.parse(f.readline)
  menu.parse_lines(f)
end

puts menu.inspect
puts "Desired total: $#{total}"

puts
puts "making 5 random orders"

5.times do
  puts menu.random_order(rand(1..20)).inspect
end

# pry
