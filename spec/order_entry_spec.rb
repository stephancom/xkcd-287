RSpec.describe OrderEntry do
  # source: https://www.reuters.com/article/us-dessert/new-yorks-25000-dessert-sets-guinness-record-idUSN0753679220071107
  let(:name) { 'Frrozen Haute Chocolate' }
  let(:price) { Money.from_amount(25_000) }
  let(:item) { Item.new(name, price.format) }

  describe 'a basic order entry' do
    let(:quantity) { 2 }
    let(:entry) { OrderEntry.new(item, quantity) }

    it 'computes a subtotal' do
      expect(entry.subtotal).to eq(price * quantity)
    end

    describe 'quantity' do
      it 'decreases' do
        expect {
          entry.quantity = 1
        }.to change { entry.quantity }.from(2).to(1)
      end

      it 'increases' do
        expect {
          entry.quantity = 10
        }.to change { entry.quantity }.from(2).to(10)
      end

      it 'changes subtotal when it changes' do
        expect {
          entry.quantity += 3
        }.to change { entry.subtotal }.from(price * quantity).to(price * (quantity + 3))
      end

      it 'fails when it becomes 0' do
        expect {
          entry.quantity = 0
        }.to raise_error(OrderEntry::InvalidQuantity)
      end

      it 'fails when it becomes negative' do
        expect {
          entry.quantity -= 3
        }.to raise_error(OrderEntry::InvalidQuantity)
      end
    end

    describe 'returned row' do
      let(:row) { entry.to_row }

      it 'has the quantity' do
        expect(row.first).to eq(quantity)
      end

      it 'has the name' do
        expect(row[1]).to eq(name)
      end

      it 'has the formatted subtotal' do
        expect(row.last).to eq((price * quantity).format)
      end
    end

    describe 'string representation' do
      let(:string) { entry.to_s }
      let(:name_expression) { /#{Regexp.quote(name)}/ }
      let(:subtotal_expression) { /#{Regexp.quote((price * quantity).format)}/ }

      it 'has the name' do
        expect(string).to match(name_expression)
      end

      it 'has the formatted subtotal' do
        expect(string).to match(subtotal_expression)
      end
    end
  end

  describe 'constructing' do
    it 'fails when quantity is 0' do
      expect {
        OrderEntry.new(item, 0)
      }.to raise_error(OrderEntry::InvalidQuantity)
    end

    it 'fails when quantity is negative' do
      expect {
        OrderEntry.new(item, -1)
      }.to raise_error(OrderEntry::InvalidQuantity)
    end
  end
end
