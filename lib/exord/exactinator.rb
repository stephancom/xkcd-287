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

    # generates a list of all possible orders with that total
    # yields to an optional block for progress reporting, etc
    # Monte Carlo method for now.
    # TODO: handling no orders.  Should be maybe true/false
    # but Monto Carlo never terminates if there's no solution.
    def run
      @orders = []
      order = Order.new(@menu)
      loop do
        yield(order.total) if block_given?
        order << @menu.random_item
        return (@orders << order) if order.total == @total
        order = Order.new(@menu) if order.total > @total
      end
    end
  end
end
