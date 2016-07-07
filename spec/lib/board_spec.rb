require 'rails_helper'
require 'game/board'

class Board
  def clear
    @state =
      [
        ['-', '-', '-'],
        ['-', '-', '-'],
        ['-', '-', '-']
      ]
  end
end

RSpec.describe Board do
  before(:each) { @board = Board.new }

  describe '#update' do
    it 'validates moves and updates the board correctly' do
      expect { @board.update(-1, 2, 'X') }.to raise_error("out of bounds")

      expect { @board.update(1, 2, 'X') }.not_to raise_error
      expect(@board.state).to eq [['-', '-', '-'], ['-', '-', 'X'], ['-', '-', '-']]

      expect { @board.update(0, 0, 'O') }.not_to raise_error
      expect(@board.state).to eq [['O', '-', '-'], ['-', '-', 'X'], ['-', '-', '-']]

      expect { @board.update(1, 3, 'X') }.to raise_error('out of bounds')

      expect { @board.update(1, -1, 'X') }.to raise_error('out of bounds')

      expect { @board.update(1, 2, 'X') }.to raise_error('someone already went there!')
    end
  end

  describe '#is_winner' do
    it 'checks the rows for winners correctly' do
      @board.update(0, 0, 'X')
      @board.update(0, 1, 'X')
      @board.update(0, 2, 'O')
      expect(@board.is_winner(0, 2, '0')).to be false

      @board.clear
      @board.update(1, 1, 'X')
      @board.update(1, 0, 'X')
      @board.update(1, 2, 'X')
      expect(@board.is_winner(1, 2, 'X')).to be true

      @board.clear
      @board.update(2, 0, 'O')
      @board.update(2, 1, 'O')
      @board.update(2, 2, 'O')
      expect(@board.is_winner(2, 2, 'O')).to be true
    end

    it 'checks the columns for winners correctly' do
      @board.update(0, 0, 'X')
      @board.update(1, 0, 'X')
      @board.update(2, 0, 'O')
      expect(@board.is_winner(2, 0, 'O')).to be false

      @board.clear
      @board.update(0, 1, 'X')
      @board.update(1, 1, 'X')
      @board.update(2, 1, 'X')
      expect(@board.is_winner(2, 1, 'X')).to be true

      @board.clear
      @board.update(0, 2, 'O')
      @board.update(1, 2, 'O')
      @board.update(2, 2, 'O')
      expect(@board.is_winner(2, 2, 'O')).to be true
    end

    it 'checks the diagonals correctly' do
      @board.update(1, 1, 'O')
      @board.update(0, 2, 'O')
      @board.update(2, 0, 'O')
      expect(@board.is_winner(2, 0, 'O')).to be true

      @board.clear
      @board.update(1, 1, 'X')
      @board.update(0, 0, 'X')
      @board.update(2, 2, 'X')
      expect(@board.is_winner(2, 2, 'X')).to be true
    end
  end

  describe '#to_s' do
    it 'prints out the board correctly' do
      @board.update(1, 1, 'O')
      @board.update(0, 0, 'X')
      expect(@board.to_s).to eq "X|-|-\n-|O|-\n-|-|-"
    end
  end
end
