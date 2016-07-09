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
    @player_to_mark_hash = { @player1 => P1_MARK, @player2 => P2_MARK }
  end

  def print_board
    @board.to_s
  end

  def make_move(i, player)
    mark = @player_to_mark_hash[player]
    x, y = i_to_x_y(i)
    @board.update(x, y, mark)
    puts "#make move"
    puts player
    @current_player = get_other_player(player)
    puts "new player: #{@current_player}"
    @board.is_winner(x, y, mark)
  end

  def print_victory_board
    winning_mark = @player_to_mark_hash[get_other_player(@current_player)]
    losing_mark = @player_to_mark_hash[@current_player]
    @board.to_s.gsub(winning_mark, ':heart_eyes:').gsub(losing_mark, ':skull:')
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
