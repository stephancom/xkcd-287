require_relative '../lib/item'
include Exord

Money.locale_backend = :currency

describe Item do
  let(:name) { 'food thing' }
  describe 'a basic item' do
    let(:price) { Money.new(2.50) }
    let(:price_string) { price.format }
    let(:item) { Item.new(name, price_string) }

    it 'has a name' do
      expect(item.name).to eq(name)
    end
    it 'has a price' do
      expect(item.price).to eq(price)
    end

    describe 'made via parsing' do
      let(:item_string) { "#{name},#{price_string}" }
      let(:item) { Item.parse(item_string) }

      it 'has a name' do
        expect(item.name).to eq(name)
      end
      it 'has a price' do
        expect(item.price).to eq(price)
      end
    end

    describe 'returned row' do
      let(:row) { item.to_row }

      it 'has the name' do
        expect(row.first).to eq(name)
      end

      it 'has the formatted price' do
        expect(row.last).to eq(price_string)
      end
    end

    describe 'string representation' do
      let(:string) { item.to_s }
      let(:name_expression) { /#{Regexp.quote(name)}/ }
      let(:price_expression) { /#{Regexp.quote(price_string)}/ }

      it 'has the name' do
        expect(string).to match(name_expression)
      end

      it 'has the formatted price' do
        expect(string).to match(price_expression)
      end
    end
  end

  describe 'constructing' do
    it 'fails when price is 0' do
      expect {
        Item.new(name, '$0')
      }.to raise_error(Item::InvalidPrice)
    end

    it 'fails when price is negative' do
      expect {
        Item.new(name, '-$2')
      }.to raise_error(Item::InvalidPrice)
    end
  end

  describe 'comparing <=> (spaceship)' do
    let(:high_price) { Item.new('Caviar', '$100.00') }
    let(:low_price) { Item.new('Peanut Butter', '$2.00') }
    let(:also_low_price) { Item.new('Grilled Cheese', '$2') }

    it 'knows when prices are in order' do
      expect(high_price <=> low_price).to eq(1)
    end

    it 'knows when prices are reversed' do
      expect(low_price <=> high_price).to eq(-1)
    end

    it 'knows when prices are equal' do
      expect(low_price <=> also_low_price).to eq(0)
    end
  end
end