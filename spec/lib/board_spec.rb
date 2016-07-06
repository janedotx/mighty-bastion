require 'rails_helper'
require 'game/board'

class Board
  def clear
    @state =
      [
        0, 0, 0,
        0, 0, 0,
        0, 0, 0
      ]
  end
end

RSpec.describe Board do
  before(:each) { @board = Board.new }

  describe '#update' do
    it 'validates moves and updates the board correctly' do
      expect { @board.update(-1, 2, 1) }.to raise_error("out of bounds")

      expect { @board.update(1, 2, 1) }.not_to raise_error
      expect(@board.state).to eq [0, 0, 0, 0, 0, 1, 0, 0, 0]

      expect { @board.update(0, 0, 2) }.not_to raise_error
      expect(@board.state).to eq [4, 0, 0, 0, 0, 1, 0, 0, 0]

      expect { @board.update(1, 3, 1) }.to raise_error('out of bounds')

      expect { @board.update(1, -1, 1) }.to raise_error('out of bounds')

      expect { @board.update(1, 2, 1) }.to raise_error('someone already went there!')
    end

    it 'checks the rows for winners correctly' do
      expect(@board.update(0, 0, 1)).to be false
      expect(@board.update(0, 1, 1)).to be false
      expect(@board.update(0, 2, 4)).to be false

      @board.clear
      expect(@board.update(1, 1, 1)).to be false
      expect(@board.update(1, 0, 1)).to be false
      expect(@board.update(1, 2, 1)).to be true

      @board.clear
      expect(@board.update(2, 0, 4)).to be false
      expect(@board.update(2, 1, 4)).to be false
      expect(@board.update(2, 2, 4)).to be true
    end

    it 'checks the columns for winners correctly' do
      expect(@board.update(0, 0, 1)).to be false
      expect(@board.update(1, 0, 1)).to be false
      expect(@board.update(2, 0, 4)).to be false

      @board.clear
      expect(@board.update(0, 1, 1)).to be false
      expect(@board.update(1, 1, 1)).to be false
      expect(@board.update(2, 1, 1)).to be true

      @board.clear
      expect(@board.update(0, 2, 4)).to be false
      expect(@board.update(1, 2, 4)).to be false
      expect(@board.update(2, 2, 4)).to be true
    end

    it 'checks the diagonals correctly' do
      @board.update(1, 1, 4)
      @board.update(0, 2, 4)
      expect(@board.update(2, 0, 4)).to be true

      @board.clear
      @board.update(1, 1, 1)
      @board.update(0, 0, 1)
      expect(@board.update(2, 2, 1)).to be true

      @board.clear
      @board.update(1, 1, 4)
      @board.update(0, 0, 1)
      expect(@board.update(2, 2, 1)).to be false
    end
  end
end
