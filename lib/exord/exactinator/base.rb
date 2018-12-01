module Exord
  module Exactinator
    # generates a list of all possible orders with a given total
    # abstract class
    class Base
      attr_reader :orders
      def initialize(menu, total)
        @menu = menu
        @total = total
        @orders = []
      end

      # @abstract Subclass is expected to implement #run
      # @!method run
      #    generate a list of all possible orders with that total
    end
  end
end
