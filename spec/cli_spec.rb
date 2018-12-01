require 'spec_helper'
require 'pry'
RSpec.describe 'exord' do
  describe '--version' do
    command 'exord --version'
    its(:stdout) { is_expected.to include(Exord::VERSION) }
  end

  describe 'with no args' do
    command 'exord', allow_error: true
    its(:stdout) { is_expected.to match(/filename.*is require.*$/) }
    its(:exitstatus) { is_expected.not_to eq(0) }
    its(:exitstatus) { is_expected.to eq(64) }
  end

  describe 'with a file not found' do
    command 'exord the_brown_derby.txt', allow_error: true
    its(:stdout) { is_expected.to match(/No such file or directory/) }
    its(:stdout) { is_expected.to include 'the_brown_derby.txt' }
    its(:exitstatus) { is_expected.not_to eq(0) }
    its(:exitstatus) { is_expected.to eq(70) }
  end

  describe 'restaurant name' do
    fixture_file 'jack_rabbit_menu.txt'

    describe 'should not be there by default' do
      command 'exord jack_rabbit_menu.txt'
      its(:stdout) { is_expected.not_to include "Jack Rabbit Slim's" }
    end

    describe 'can be specified on the command line' do
      command "exord -r \"Jack Rabbit Slim's\" jack_rabbit_menu.txt"
      its(:stdout) { is_expected.to include "Jack Rabbit Slim's" }
    end
  end

  describe 'given a simple menu' do
    file 'billygoat.txt', <<~EOGOAT
      $5.80
      Cheezborger "original",$3.15
      Hamborger,$2.95
      Pepsi,$1.65
      Chips,$1
    EOGOAT

    describe 'with defaults' do
      command 'exord billygoat.txt'
      it 'should include the menu' do
        expect(subject.stdout).to include(
          <<~PLAINMENU
            +------------------------+-------+
            |              Menu              |
            +------------------------+-------+
            | Item                   | Cost  |
            +------------------------+-------+
            | Chips                  | $1.00 |
            | Pepsi                  | $1.65 |
            | Hamborger              | $2.95 |
            | Cheezborger "original" | $3.15 |
            +------------------------+-------+
          PLAINMENU
        )
      end
      it 'should include the default solution' do
        expect(subject.stdout).to include(
          <<~UNDERSIXBUCKS
            +----------+------------------------+-------+
            |               Total: $5.80                |
            +----------+------------------------+-------+
            | Quantity | Item                   | Cost  |
            +----------+------------------------+-------+
          UNDERSIXBUCKS
        )
      end
      its(:stdout) { is_expected.to include('| 1        | Cheezborger "original" | $3.15 |') }
      its(:stdout) { is_expected.to include('| 1        | Chips                  | $1.00 |') }
      its(:stdout) { is_expected.to include('| 1        | Pepsi                  | $1.65 |') }
    end

    describe 'specifying the restaurant name' do
      command 'exord -r "Billy Goat Tavern" billygoat.txt'
      it 'should include the menu with title' do
        expect(subject.stdout).to include(
          <<~BILLYGOATMENU
            +------------------------+-------+
            |       Billy Goat Tavern        |
            +------------------------+-------+
            | Item                   | Cost  |
            +------------------------+-------+
            | Chips                  | $1.00 |
            | Pepsi                  | $1.65 |
            | Hamborger              | $2.95 |
            | Cheezborger "original" | $3.15 |
            +------------------------+-------+
          BILLYGOATMENU
        )
      end
    end

    describe 'specifying the total allowing for only one item' do
      command 'exord -t 2.95 billygoat.txt'
      it 'should include the expected solution' do
        expect(subject.stdout).to include(
          <<~JUSTABURGER
            +----------+-----------+-------+
            |         Total: $2.95         |
            +----------+-----------+-------+
            | Quantity | Item      | Cost  |
            +----------+-----------+-------+
            | 1        | Hamborger | $2.95 |
            +----------+-----------+-------+
          JUSTABURGER
        )
      end
    end
  end
end
