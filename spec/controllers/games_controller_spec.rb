require 'rails_helper'

class GameManager
  def self.clear
    @@games = {}
  end
end

RSpec.describe GamesController, type: :controller do
  before(:each) do
    GameManager.clear
  end

  describe 'POST challenge' do
    it 'should create a new game with the correct channel_id and players' do
      post :challenge, { channel_id: 'channel_id',  user_name: 'ham', text: 'eggs' }
      expect(response.body).to eq 'ham has challenged eggs to a game of tic tac toe!'

      game = GameManager.games['channel_id']
      expect(game).to_not be nil
      expect(game.player1).to eq 'eggs'
      expect(game.player2).to eq 'ham'
      expect(game.current_player).to eq 'eggs'
    end

    it 'should support multiple games, each in a different channel' do
      post :challenge, { channel_id: 'channel_id',  user_name: 'ham', text: 'eggs' }

      channel_id_game = GameManager.games['channel_id']
      expect(channel_id_game).to_not be nil
      expect(channel_id_game.current_player).to eq 'eggs'

      post :challenge, { channel_id: 'fox_channel',  user_name: 'ham', text: 'toast' }
      fox_channel_game = GameManager.games['fox_channel']
      expect(fox_channel_game).to_not be nil
      expect(fox_channel_game.current_player).to eq 'toast'
    end

    it 'should not allow new challenges while a game is in progress in a channel' do
      post :challenge, { channel_id: 'channel_id',  user_name: 'ham', text: 'eggs' }
      expect(response.body).to eq 'ham has challenged eggs to a game of tic tac toe!'

      post :challenge, { channel_id: 'channel_id',  user_name: 'ham', text: 'eggs' }
      expect(response.body).to eq 'A game between eggs and ham is already ongoing!'
    end
  end

  describe 'GET help' do
    it 'should respond with help text' do
      get :help
      expect(response.body).to_not be nil
    end
  end

  describe 'POST move' do
    it 'should do nothing if no game exists for this channel' do
    end
  end
end
