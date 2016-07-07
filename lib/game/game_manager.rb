require_relative 'game'

class GameManager
  # channel-game mapping
  @@games = {}
  class << self
    def games
      @@games
    end

    # Player1 will always be the challenged player and gets to go first.
    def start_new_game(channel_id:, challenged:, challenger:)
      @@games[channel_id] = Game.new(challenged: challenged, challenger: challenger)
    end

    def print_game(channel_id)
      # what if there is no game for this channel?
    end
  end
end
