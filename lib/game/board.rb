require_relative 'game_exception'

class Board
# Manage and query the state of the board.
  attr_reader :state

  def initialize
    @state =
      [
        ['-', '-', '-'],
        ['-', '-', '-'],
        ['-', '-', '-']
      ]
  end

  # Update the board with only valid moves.
  def update(x, y, player)
    raise GameException.new('out of bounds') if x < 0 || x > 2 || y < 0 || y > 2
    raise GameException.new('someone already went there!') if @state[x][y] != '-'

    @state[x][y] = player
  end

  # See if the most recent move has resulted in the game ending.
  def is_winner(x, y, player)
    return true if check_row(x, player)
    return true if check_col(y, player)
    return true if check_diagonals(player)
    return false
  end

  # Detect whether there are valid moves left.
  def is_full
    count(@state.flatten, '-') == 0
  end

  def to_s
    arr = @state.map do |row|
      row.join('|')
    end
    arr.join("\n")
  end

  private

  def count(arr, mark)
    arr.count { |move| move == mark }
  end

  def check_row(x, player_mark)
    return count(@state[x], player_mark) == 3
  end

  def check_col(y, player_mark)
    col_arr = [@state[0][y], @state[1][y], @state[2][y]]
    return count(col_arr, player_mark) == 3
  end

  # Might as well check both diagonals without trying to figure out which diagonal a move might be on, since the logic is
  # simpler that way. Thankfully, a tic tac toe board is not large.
  def check_diagonals(player_mark)
    left_diag_arr = [@state[0][0], @state[1][1], @state[2][2]]
    right_diag_arr = [@state[0][2], @state[1][1], @state[2][0]]
    return true if count(left_diag_arr, player_mark) == 3
    return true if count(right_diag_arr, player_mark) == 3
    return false
  end
end
