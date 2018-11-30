require 'monetize'
module Exord
  # models a single menu item with a name and price
  class Item
    attr_reader :price
    protected :price

    def initialize(name, price)
      @name = name
      @price = Monetize.parse(price)
    end

    def to_s
      "#{@name}: $#{@price}"
    end

    def to_row
      [@name, @price]
    end

    def <=>(other)
      @price <=> other.price
    end
  end
end
