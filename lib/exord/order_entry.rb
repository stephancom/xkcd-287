module Exord
  # a single line item from an order
  class OrderEntry
    attr_reader :item, :quantity
    def initialize(item, quantity = 1)
      @item = item
      raise InvalidQuantity if quantity < 1
      @quantity = quantity
    end
    
    def subtotal
      @item.price * quantity
    end

    def quantity=(new_quantity)
      raise InvalidQuantity if new_quantity < 1
      @quantity = new_quantity
    end

    def self.headings
      %w[Quantity Item Cost]
    end

    def to_row
      [@quantity, @item.name, subtotal.format]
    end

    def to_s
      "#{@quantity} #{@item.name}/@#{@item.price.format}: #{subtotal.format}"
    end

    class InvalidQuantity < StandardError; end
  end
end