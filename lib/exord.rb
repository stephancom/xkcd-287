require 'monetize'
require 'terminal-table'
require 'exord/version'
require 'exord/item'
require 'exord/menu'
require 'exord/order'
require 'exord/entry'
require 'exord/exactinator'

module Exord
  class InvalidPrice < StandardError; end
  class InvalidQuantity < StandardError; end
  class InvalidItem < StandardError; end
  # Your code goes here...
end
