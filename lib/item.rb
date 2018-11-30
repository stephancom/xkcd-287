require 'monetize'
module Exord
  # a single menu item with a name and price
  class Item
    attr_reader :name
    attr_reader :price

    def initialize(name, price_string)
      @name = name.strip
      @price = Monetize.parse(price_string)
      raise InvalidPrice if @price <= Money.new(0)
    end

    # yes, this fails if there is a comma in the item name
    # TODO: proper CSV import.
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

    class InvalidPrice < StandardError; end
  end
end
