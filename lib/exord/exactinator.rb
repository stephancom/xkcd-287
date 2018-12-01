module Exord
  # service to generate all orders for a menu with a given total
  # total is expected in money format
  class Exactinator
    attr_reader :orders
    def initialize(menu, total)
      @menu = menu
      @total = total
      @orders = []
    end

    # return a list of all possible orders with that total
    # yields to an optional block for progress reporting, etc
    # Monte Carlo method for now.
    # TODO: handling no orders.  Should be maybe true/false
    # but Monto Carlo never terminates if there's no solution.
    def run
      @orders = []
      loop do
        order = Order.new(@menu)
        loop do
          order << @menu.random_item
          break unless order.total < @total
        end
        yield(order.total) if block_given?
        if order.total == @total
          @orders << order
          break
        end
      end
    end
  end
end
