module Exord
  # models an order - a collection of items and quantities
  # ... it would be nice to associate it with a Menu and
  # raise an exception if you try to add an item not on the menu
  class Order
    def initialize(items = [])
      @entries = []
      items.each do |item|
        add_item(item)
      end
    end

    def add_item(item, quantity = 1)
      # check for duplicates - probably not terribly efficient
      dupe = @entries.find_index { |entry| entry.item == item }
      if dupe.nil?
        @entries << OrderEntry.new(item, quantity)
      else
        raise OrderEntry::InvalidQuantity if quantity < 1
        @entries[dupe].quantity += quantity
      end
    end

    def <<(item)
      add_item(item)
    end

    def total
      return Money.new(0) if @entries.empty?
      @entries.inject(0) { |sum, entry| sum + entry.subtotal }
    end

    def inspect
      Terminal::Table.new(title: "Total: #{total.format}",
                          headings: OrderEntry.headings,
                          rows: @entries.map(&:to_row)).to_s
    end
  end
end