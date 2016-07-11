require 'rails_helper'
require 'game/game'


RSpec.describe Game do
  before(:each) do
    @game = Game.new(challenged: 'ham', challenger: 'eggs')
  end

  describe '#initialize' do
    it 'sets up the players correctly' do
      expect(@game.player1).to eq 'ham'
      expect(@game.player2).to eq 'eggs'
      expect(@game.next_player).to eq 'ham'
    end
  end

  describe '#make_move' do
    it 'only lets the correct player make a move' do
      expect { @game.make_move(1, 'eggs') }.to raise_error(GameException, "It isn't your turn!")
    end

    it 'updates the next player correctly' do
      @game.make_move(1, 'ham')
      expect(@game.next_player).to eq 'eggs'
    end

    it 'returns the correct status code when there is a winner and only when there is a winner' do
      expect(@game.make_move(1, 'ham')).to eq :continue
      expect(@game.make_move(4, 'eggs')).to eq :continue
      expect(@game.make_move(2, 'ham')).to eq :continue
      expect(@game.make_move(7, 'eggs')).to eq :continue
      expect(@game.make_move(3, 'ham')).to eq :winner
    end

    it 'returns the correct status code when there is a tie and only when there is a tie' do
      expect(@game.make_move(1, 'ham')).to eq :continue
      expect(@game.make_move(3, 'eggs')).to eq :continue
      expect(@game.make_move(2, 'ham')).to eq :continue
      expect(@game.make_move(4, 'eggs')).to eq :continue
      expect(@game.make_move(5, 'ham')).to eq :continue
      expect(@game.make_move(8, 'eggs')).to eq :continue
      expect(@game.make_move(6, 'ham')).to eq :continue
      expect(@game.make_move(9, 'eggs')).to eq :continue
      expect(@game.make_move(7, 'ham')).to eq :tie
    end
  end

  describe '#print_victory_board' do
    it 'should correctly gif-ify the board' do
      @game.make_move(1, 'ham')
      @game.make_move(4, 'eggs')
      @game.make_move(2, 'ham')
      @game.make_move(7, 'eggs')
      @game.make_move(3, 'ham')

      expect(@game.print_victory_board).to eq ":heart_eyes:|:heart_eyes:|:heart_eyes:\n"\
                                              ":skull:|-|-\n"\
                                              ":skull:|-|-"
    end
  end

  describe '#print_cheating_board' do
    it 'should correctly print out the cheater board' do
      expect(@game.print_cheating_board).to eq ":heart_eyes:|-|-\n"\
                                              "-|:heart_eyes:|-\n"\
                                              "-|-|:heart_eyes:"
    end
  end
end
