require_relative 'game_exception'

class Board
  attr_reader :state

  def initialize
    @state =
      [
        ['-', '-', '-'],
        ['-', '-', '-'],
        ['-', '-', '-']
      ]
  end

  def update(x, y, player)
    raise GameException.new('out of bounds') if x < 0 || x > 2 || y < 0 || y > 2
    raise GameException.new('someone already went there!') if @state[x][y] != '-'

    @state[x][y] = player
  end

  def is_winner(x, y, player)
    return true if check_row(x, player)
    return true if check_col(y, player)
    return true if check_diagonals(player)
    return false
  end

  def to_s
    "#{@state[0][0]}|#{@state[0][1]}|#{@state[0][2]}\n" +
    "#{@state[1][0]}|#{@state[1][1]}|#{@state[1][2]}\n" +
    "#{@state[2][0]}|#{@state[2][1]}|#{@state[2][2]}"
  end

  private

  def count(arr, mark)
    puts 'count'
    arr.count { |move| puts "move: #{move} #{move == mark}"; move == mark }
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
    puts 'playermark'
    puts player_mark
    puts 'check diagnoals'
    left_diag_arr = [@state[0][0], @state[1][1], @state[2][2]]
    puts 'left diag arr'
    puts left_diag_arr[0] == 'X'
    right_diag_arr = [@state[0][2], @state[1][1], @state[2][0]]
    puts 'right diag arr'
    puts right_diag_arr.inspect
    puts 'count left diag arr'
    puts count(left_diag_arr, player_mark)
    return true if count(left_diag_arr, player_mark) == 3
    return true if count(right_diag_arr, player_mark) == 3
    return false
  end
end
