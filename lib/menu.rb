require 'terminal-table'
module Exord
  # a collection of menu items
  class Menu
    attr_reader :items

    def initialize(title = 'Menu', items = [])
      @title = title
      @items = items
    end

    def add_item(item)
      @items << item
    end
    alias << add_item

    def parse_lines(f)
      f.each do |line|
        @items << Item.parse(line)
      end
    end

    def to_s
      @title
    end

    def inspect
      Terminal::Table.new title: @title,
                          headings: Item.headings,
                          rows: @items.sort.map(&:to_row)
    end
  end
end
