require 'simplecov'
SimpleCov.start

require_relative '../lib/item'
require_relative '../lib/menu'
require_relative '../lib/order'
require_relative '../lib/order_entry'
include Exord

Money.locale_backend = :currency
