module Exord
  module Exactinator
    # Monte Carlo method for finding one possible order
    class MonteCarlo < Base
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
end
