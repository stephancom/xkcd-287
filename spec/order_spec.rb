RSpec.describe Order do
  # source: https://youtu.be/iuE_a1pTsO4
  # yeah, yeah, prices ought to be in pounds.  i18n wasn't in the spec.
  let(:menu) { Menu.new('Frog and Peach') }
  let(:fp_price) { Money.from_amount(12.34) }
  let(:frog_a_la_peche) { Item.new('frog a la peche', fp_price.format) }
  let(:pf_price) { Money.from_amount(44.33) }
  let(:peche_a_la_frog) { Item.new('peche a la frog', pf_price.format) }
  let(:mint_price) { Money.from_amount(0.25) }
  let(:mint) { Item.new('after dinner mint', mint_price.format) }
  let(:coq_au_vin) { Item.new('Coq au Vin', '$6.99') } # not on offer

  before do
    menu << frog_a_la_peche
    menu << peche_a_la_frog
    menu << mint
  end

  describe 'an order' do
    let(:order) { Order.new(menu) }
    before do
      order << frog_a_la_peche
      order << peche_a_la_frog
    end

    it 'should have the right number of items' do
      expect(order.items_count).to eq(2)
    end

    it 'should have the right total' do
      expect(order.total).to eq(fp_price + pf_price)
    end

    describe 'adding one new item' do
      it 'should have the right number of items' do
        expect {
          order << mint
        }.to change { order.items_count }.from(2).to(3)
      end

      it 'should have the right total' do
        expect {
          order << mint
        }.to change { order.total }.by(mint_price)
      end
    end

    describe 'adding multiples of one new item' do
      it 'should have the right number of items' do
        expect {
          order.add_item(mint, 3)
        }.to change { order.items_count }.from(2).to(5)
      end

      it 'should have the right total' do
        expect {
          order.add_item(mint, 4)
        }.to change { order.total }.by(mint_price * 4)
      end
    end

    describe 'adding an existing item' do
      it 'should have the right number of items' do
        expect {
          order << frog_a_la_peche
        }.to change { order.items_count }.from(2).to(3)
      end

      it 'should have the right total' do
        expect {
          order << frog_a_la_peche
        }.to change { order.total }.by(fp_price)
      end

      describe 'twice' do
        before do
          order << peche_a_la_frog
          order << peche_a_la_frog
        end

        it 'should have the right number of items' do
          expect(order.items_count).to eq(4)
        end

        it 'should have the right total' do
          expect(order.total).to eq(pf_price * 3 + fp_price)
        end

        # yeah, it's bad form to inspect internal state, I'm torn whether to expose this or not
        it 'should have the right number of entries' do
          expect(order.instance_variable_get(:@entries).count).to eq(2)
        end
      end
    end

    it 'should fail to add an item not on the menu' do
      expect {
        order << coq_au_vin
      }.to raise_error(InvalidItem)
    end

    describe 'the table returned by inspect' do
      subject { order.inspect }
      it { is_expected.to match(/frog a la peche/) }
      it { is_expected.to match(/peche a la frog/) }
      it { is_expected.to match(/\$56.67/) }
    end
  end
end
