module Exord
  # models an order - a collection of items and quantities
  class Order
    attr_reader :entries
    def initialize(menu)
      @menu = menu
      @entries = []
    end

    def add_item(item, quantity = 1)
      # check for duplicates and inclusion on menu - probably not terribly efficient
      raise InvalidItem unless @menu.include?(item)

      dupe = @entries.find_index { |entry| entry.item == item }
      if dupe.nil?
        @entries << Entry.new(item, quantity)
      else
        raise InvalidQuantity if quantity < 1

        @entries[dupe].quantity += quantity
      end
    end

    def <<(item)
      add_item(item)
    end

    # mostly for debugging, maybe should be removed?
    def items_count
      @entries.sum(&:quantity)
    end

    def total
      return Money.new(0) if @entries.empty?

      @entries.inject(0) { |sum, entry| sum + entry.subtotal }
    end

    def inspect
      Terminal::Table.new(title: "Total: #{total.format}",
                          headings: Entry.headings,
                          rows: @entries.map(&:to_row)).to_s
    end
  end
end
