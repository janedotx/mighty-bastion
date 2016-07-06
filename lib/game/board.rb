class Board
  attr_reader :state

  P1_MARK = 1
  P2_MARK = 4

  def initialize
    @state =
      [
        0, 0, 0,
        0, 0, 0,
        0, 0, 0
      ]
  end

  def update(x, y, player)
    raise 'out of bounds' if x < 0 || x > 2 || y < 0 || y > 2

    player_mark = player == 1 ? P1_MARK : P2_MARK
    index = convert_x_y_to_i(x, y)
    raise 'someone already went there!' if @state[index] != 0

    @state[index] = player_mark
    is_winner(x, y, player_mark)
  end

  def to_s
    "#{@state[0]}|#{@state[1]}|#{@state[2]}}\n" +
    "#{@state[3]}|#{@state[4]}|#{@state[5]}}\n" +
    "#{@state[6]}|#{@state[7]}|#{@state[8]}}\n" +
  end

  private

  def state_to_s(state)
    state == 1 ? 'X' : 'O'
  end

  def convert_x_y_to_i(x, y)
    3 * x + y
  end

  def check_row(x, player_mark)
    return true if @state[3 * x] + @state[3 * x + 1] + @state[3 * x + 2] == 3 * player_mark
    return false
  end

  def check_col(y, player_mark)
    return true if @state[y] + @state[y + 3] + @state[y + 6] == 3 * player_mark
    return false
  end

  # Might as well check both diagonals, since the logic is simpler that way. Thankfully, a tic tac toe board is not large.
  def check_diagonals(player_mark)
    return true if @state[2] + @state[4] + @state[6] == 3 * player_mark
    return true if @state[0] + @state[4] + @state[8] == 3 * player_mark
    return false
  end

  def is_winner(x, y, player)
    return true if check_row(x, player)
    return true if check_col(y, player)
    return true if check_diagonals(player)
    return false
  end
end
