RSpec.describe Menu do
  let(:menu_lines) { SLIM_MENU.split }

  # expect item count change
  describe 'a simple menu' do
    # source: https://becomethesolution.com/blogs/chicago-restaurant-menus/billy-goat-tavern-carry-out-menu-chicago
    let(:name) { 'Billy Goat Tavern' }
    let(:cheezborger) { Item.new('Cheezborger "original"', '$3.15') }
    let(:hamborger) { Item.new('Hamborger', '$2.95') }
    let(:pepsi) { Item.new('No Coke; Pepsi', '$1.65') }
    let(:chips) { Item.new('Chips', '$1') }
    let(:fries) { Item.new('Fries', '$1.80') }
    let(:menu) { Menu.new(name) }

    before do
      menu << cheezborger
      menu << hamborger
      menu << pepsi
      menu << chips
    end

    it 'should have the correct number of items' do
      expect(menu.items.count).to eq(4)
    end

    it 'should return the name in the string representation' do
      expect(menu.to_s).to match(/Billy Goat Tavern/)
    end

    it 'should change the count when adding an item' do
      expect {
        menu << fries
      }.to change { menu.items.count }.by(1)
    end

    it 'should not add a duplicate item' do
      expect {
        menu << pepsi
      }.not_to change { menu.items.count }
    end

    describe 'membership' do
      it 'should be true when item is in menu' do
        expect(menu.include?(cheezborger)).to be true
      end

      it 'should be false when the item is not in menu' do
        expect(menu.include?(fries)).to be false
      end
    end

    describe 'the table returned by inspect' do
      subject { menu.inspect }
      it { is_expected.to match(/Billy Goat Tavern/) }
      it { is_expected.to match(/Cheezborger/) }
      it { is_expected.to match(/\$3.15/) }
      it { is_expected.not_to match(/fries/) }
    end

    it 'should generate a random item' do
      expect(menu.random_item).to be_an_instance_of(Item)
    end

    describe 'creating a random order' do
      let(:items) { 5 }
      let(:order) { menu.random_order(items) }

      it 'should have the right number of items' do
        expect(order.items_count).to eq(items)
      end
    end
  end

  describe 'parsing' do
    # source: https://www.restaurantchoice.co.uk/blog/six-fictional-menus-that-should-be-real
    let(:title) { 'Jack Rabbit Slims' }
    let(:menu_text) {
      <<~MENU
        The Fabienne Breakfast,$10
        Strawberry Pop Tarts,$3
        Honey Bunny & Pumpkin Pie,$7
        Big Kahuna Burger,$11
        Le Royale with Cheese,$12
        Durward Kirby Burger w/ Bacon,$13
        Douglas Sirk Steak,$18
        French Fries,$5
        Zed's Bread Baby,$3.50
        Beer,$6
        Sprite,$3.50
        Jimmy's Serious Gourmet Coffee,$3
        Shakes,$5
      MENU
    }
    let(:menu_lines) { menu_text.split("\n") }
    let(:menu) { Menu.new(title) }

    it 'should parse successfully' do
      expect {
        menu.parse_lines(menu_lines)
      }.not_to raise_error
    end

    describe 'when parsed' do
      before do
        menu.parse_lines(menu_lines)
      end

      it 'should have the right number of entries' do
        expect(menu.items.count).to eq(13)
      end
    end
  end
end
