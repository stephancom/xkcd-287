module Exord
  # a collection of menu items
  class Menu
    attr_reader :items

    def initialize(title = 'Menu')
      @title = title.strip
      @items = SortedSet.new
    end

    def add_item(item)
      @items << item
    end
    alias << add_item

    def parse_lines(lines)
      lines.each do |line|
        @items << Item.parse(line)
      end
    end

    def to_s
      @title
    end

    def inspect
      Terminal::Table.new(title: @title,
                          headings: Item.headings,
                          rows: @items.sort.map(&:to_row)).to_s
    end

    # create a random order of N (non-unique) items
    # handy for testing and monte carlo method
    def random_item
      items.to_a.sample
    end

    def random_order(num_items)
      Order.new.tap do |random_order|
        num_items.times do
          random_order << random_item
        end
      end
    end
  end
end
