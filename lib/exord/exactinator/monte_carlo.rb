module Exord
  module Exactinator
    # Monte Carlo method for finding one possible order
    class MonteCarlo < Base
      # Monto Carlo never terminates if there's no solution.
      # left in as a trivial example, useful for debugging.
      def run
        @orders = []
        order = Order.new(@menu)
        loop do
          order << @menu.random_item
          return (@orders << order) if order.total == @total

          order = Order.new(@menu) if order.total > @total
        end
      end
    end
  end
end
