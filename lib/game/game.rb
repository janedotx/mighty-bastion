require_relative 'board'

class Game
  attr_reader :player1, :player2, :current_player

  P1_MARK = 'X'
  P2_MARK = 'O'
  # current player
  # eligible players
  # player mapping
  def initialize(challenged:, challenger:)
    @player1 = challenged
    @player2 = challenger
    @board = Board.new
    @current_player = challenged
  end

  def print_board
    @current_board.to_s
  end

  def make_move(x, y, player)
    mark = (player == @player1) ? P1_MARK : P2_MARK
    @board.update(x, y, player)
    @current_player = get_other_player(player)
    @board.is_winner(x, y, player)
  end

  private

  def get_other_player(player)
    @player2 if @player1 == player
    @player1
  end
end
