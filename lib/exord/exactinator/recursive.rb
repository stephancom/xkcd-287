module Exord
  module Exactinator
    # recursive method for finding all possible orders
    class Recursive < Base
      def run
        menu_items = @menu.items.to_a.sort.reverse # high to low

        @orders = exact_orders_with_items(menu_items, @total)
      end

      private

      def exact_orders_with_items(items, subtotal)
        suborders = []
        return suborders if items.empty? || subtotal <= 0

        # start by popping off the first (most expensive item)
        item = items.first # for some reason, shift doesn't work?
        items = items[1..-1]

        # a float of how many items fit in the price
        max_of_item = subtotal / item.price

        # trivially check to see if some multiple
        # of this one item makes the subtotal
        if (max_of_item % 1).zero?
          suborders << Order.new(@menu).tap do |simple_order|
            simple_order.add_item(item, max_of_item.to_i)
          end
        end

        return suborders if items.empty?

        # finally, for each possible number of this item (including none)
        # find order of remaining items with a total equal to the previous
        # subtotal minus the cost of the given number of this item
        (0..max_of_item.floor).each do |quantity|
          new_subtotal = subtotal - (item.price * quantity)
          exact_orders_with_items(items, new_subtotal).each do |order|
            order.add_item(item, quantity) if quantity.positive?
            suborders << order
          end
        end

        suborders
      end
    end
  end
end
