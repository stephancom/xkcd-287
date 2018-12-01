RSpec.describe Exactinator do
  let(:menu) { Menu.new('Billy Goat Tavern') }
  let(:hamborger) { Item.new('Hamborger', '$2.95') }
  before do
    menu << Item.new('Cheezborger "original"', '$3.15')
    menu << hamborger
    menu << Item.new('Pepsi', '$1.65')
    menu << Item.new('Chips', '$1')
  end
  let(:total) { 2.95.to_money }
  let(:exactinator) { Exactinator::MonteCarlo.new(menu, total) }

  it 'should yield' do
    expect { |b|
      exactinator.run(&b)
    }.to yield_control
  end

  it 'should start with no orders' do
    expect(exactinator).to have(0).orders
  end

  describe 'results after running' do
    before do
      exactinator.run
    end
    subject(:results) { exactinator.orders }

    it { is_expected.to be_an_instance_of(Array) }
    it { is_expected.to all(be_an_instance_of(Order)) }
    it { is_expected.not_to be_empty }
    it { is_expected.to have_exactly(1).order }

    describe 'found one order' do
      subject(:order) { results.first }

      it { is_expected.to have_exactly(1).entries }
      it 'should have exactly one item' do
        expect(order.items_count).to eq(1)
      end
      it 'should have the right total' do
        expect(order.total).to eq(total)
      end

      describe 'with one entry' do
        subject(:entry) { order.entries.first }

        it 'should have a quantity of one' do
          expect(entry.quantity).to eq(1)
        end
        it 'should be a hamborger' do
          expect(entry.item).to eq(hamborger)
        end
      end
    end
  end
end
