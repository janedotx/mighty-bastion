require_relative 'game'

class GameManager
  # channel-game mapping
  @@games = {}
  class << self
    def delete(channel_id)
      @@games.delete(channel_id)
    end

    def fetch(channel_id)
      @@games[channel_id]
    end

    # Player1 will always be the challenged player and gets to go first.
    def start_new_game(channel_id:, challenged:, challenger:)
      @@games[channel_id] = Game.new(challenged: challenged, challenger: challenger)
    end

    def print_game(channel_id)
      game = @@games[channel_id]
      return "No ongoing game! You should challenge someone." if @@games[channel_id].nil?
      return game.print_board
    end
  end
end
