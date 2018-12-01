module Exord
  module Exactinator
    class Recursive < Base
      def run
        @orders = []

        order = Order.new(@menu)
        menu_items = @menu.items.to_a.sort.reverse # high to low

        @orders = exact_orders_with_items(menu_items, @total)
        yield(@total) if block_given?

        @orders.any?
      end

      private

      def exact_orders_with_items(items, subtotal)
        suborders = []
        return suborders if items.empty? || subtotal <= 0

        # start by popping off the first (most expensive item)
        item = items.first

        # a float of how many items fit in the price
        max_of_item = subtotal/item.price

        # then, trivially check to see if some multiple
        # of this one item makes the subtotal
        if max_of_item % 1 == 0
          suborders << Order.new(@menu).tap do |simple_order|
            simple_order.add_item(item, max_of_item.to_i)
            simple_order
          end
        end

        # finally, for each possible number of this item (including none)
        # find suborders of remaining items minus this item
        remains = items[1..-1]
        if remains.any?
          (0..max_of_item.floor).each do |quantity|
            new_sub = subtotal - (item.price * quantity)
            exact_orders_with_items(remains, new_sub).each do |order|
              order.add_item(item, quantity) unless quantity == 0
              suborders << order
            end
          end
        end

        suborders
      end
    end
  end
end
