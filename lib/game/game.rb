require_relative 'board'
require_relative 'game_exception'

class Game
# Manage game logic and board visualization.
  attr_reader :player1, :player2, :next_player

  P1_MARK = 'X'
  P2_MARK = 'O'

  def initialize(challenged:, challenger:)
    @player1 = challenged
    @player2 = challenger
    @board = Board.new
    @next_player = challenged
    # Necessary for the sake of being able to map player names to the traditional Xs and Os.
    @player_to_mark_hash = { @player1 => P1_MARK, @player2 => P2_MARK }
  end

  def print_board
    @board.to_s
  end

  # It seems easier to allow players to specify the index of the move they want to make as if the board
  # were a one-dimensional array. Otherwise, using traditional Cartesian coordinates, (0, 0) would be the
  # lower lefthand corner, but that conflicts with the how the game programmer would use array indices to
  # access the board state.
  def make_move(i, player)
    raise GameException.new("It isn't your turn!") if player != @next_player

    mark = @player_to_mark_hash[player]
    x, y = i_to_x_y(i)
    @board.update(x, y, mark)
    @next_player = get_other_player(player)
    return :winner if @board.is_winner(x, y, mark)
    return :tie if @board.is_full
    return :continue
  end

  def print_victory_board
    winning_mark = @player_to_mark_hash[get_other_player(@next_player)]
    losing_mark = @player_to_mark_hash[@next_player]
    @board.to_s.gsub(winning_mark, ':heart_eyes:').gsub(losing_mark, ':skull:')
  end

  def print_cheating_board
    board = Board.new
    [0, 1, 2].each do |i|
      board.update(i, i, ':heart_eyes:')
    end
    board.to_s
  end

  private

  def get_other_player(player)
    return @player2 if @player1 == player
    @player1
  end

  def i_to_x_y(i)
    x = (i - 1) / 3
    y = (i - 1) % 3
    [x, y]
  end
end
