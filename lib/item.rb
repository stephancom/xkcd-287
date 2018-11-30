require 'monetize'
module Exord
  # a single menu item with a name and price
  class Item
    attr_reader :name
    attr_reader :price

    def initialize(name, price)
      @name = name
      @price = Monetize.parse(price)
    end

    def self.parse(string)
      new(*string.chomp.split(','))
    end

    def self.headings
      %w[Item Cost]
    end

    def to_row
      [@name, @price.format]
    end

    def to_s
      "#{@name}: $#{@price}"
    end

    def <=>(other)
      @price <=> other.price
    end
  end
end
