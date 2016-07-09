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
    it 'should not let you challenge yourself' do
      post :challenge, { channel_id: 'channel_id',  user_name: 'ham', text: 'ham', token: '2g4fusktmXo8GikeHiAduMsK' }
      expect(get_text(response)).to eq 'You may not challenge yourself.'
    end

    it 'should create a new game with the correct channel_id and players' do
      post :challenge, { channel_id: 'channel_id',  user_name: 'ham', text: 'eggs', token: '2g4fusktmXo8GikeHiAduMsK' }
      expect(get_text(response)).to eq 'ham has challenged eggs to a game of tic tac toe!'

      game = GameManager.fetch('channel_id')
      expect(game).to_not be nil
      expect(game.player1).to eq 'eggs'
      expect(game.player2).to eq 'ham'
      expect(game.next_player).to eq 'eggs'
    end

    it 'should support multiple games, each in a different channel' do
      post :challenge, { channel_id: 'channel_id',  user_name: 'ham', text: 'eggs', token: '2g4fusktmXo8GikeHiAduMsK' }

      channel_id_game = GameManager.fetch('channel_id')
      expect(channel_id_game).to_not be nil
      expect(channel_id_game.next_player).to eq 'eggs'

      post :challenge, { channel_id: 'fox_channel',  user_name: 'ham', text: 'toast', token: '2g4fusktmXo8GikeHiAduMsK' }
      fox_channel_game = GameManager.fetch('fox_channel')
      expect(fox_channel_game).to_not be nil
      expect(fox_channel_game.next_player).to eq 'toast'
    end

    it 'should not allow new challenges while a game is in progress in a channel' do
      post :challenge, { channel_id: 'channel_id',  user_name: 'ham', text: 'eggs', token: '2g4fusktmXo8GikeHiAduMsK' }
      expect(get_text(response)).to eq 'ham has challenged eggs to a game of tic tac toe!'

      post :challenge, { channel_id: 'channel_id',  user_name: 'ham', text: 'eggs', token: '2g4fusktmXo8GikeHiAduMsK' }
      expect(get_text(response)).to eq 'A game between eggs and ham is already ongoing!'
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
      post :move, { channel_id: 'fox_channel', token: '2g4fusktmXo8GikeHiAduMsK' }
      expect(response.body).to eq "No game is currently ongoing. You should challenge someone!"
    end

    it 'should make a move if there is a game and the correct player makes a move' do
      GameManager.start_new_game(channel_id: 'fox', challenged: 'ham', challenger: 'eggs')
      post :move, { channel_id: 'fox', user_name: 'ham', text: '5', token: '2g4fusktmXo8GikeHiAduMsK' }
      expect(get_text(response)).to eq "ham has made a move.\n"\
                                  "-|-|-\n"\
                                  "-|X|-\n"\
                                  "-|-|-"
      post :move, { channel_id: 'fox', user_name: 'eggs', text: '6', token: '2g4fusktmXo8GikeHiAduMsK' }
      expect(get_text(response)).to eq "eggs has made a move.\n"\
                                  "-|-|-\n"\
                                  "-|X|O\n"\
                                  "-|-|-"
    end

    it 'should not make a move if there is a game and the wrong player makes a move' do
      GameManager.start_new_game(channel_id: 'fox', challenged: 'ham', challenger: 'eggs')
      post :move, { channel_id: 'fox', user_name: 'eggs', text: '5', token: '2g4fusktmXo8GikeHiAduMsK' }
      expect(get_text(response)).to eq "It isn't your turn!"

      post :move, { channel_id: 'fox', user_name: 'ham', text: '6', token: '2g4fusktmXo8GikeHiAduMsK' }
      expect(get_text(response)).to match /ham has made a move/

      post :move, { channel_id: 'fox', user_name: 'ham', text: '7', token: '2g4fusktmXo8GikeHiAduMsK' }
      expect(get_text(response)).to eq "It isn't your turn!"
    end

    it 'should not let a player move out of bounds' do
    end

    it 'should make a move, conclude the game if the move was a game-ender, and clear the channel of any games' do
      game = GameManager.start_new_game(channel_id: 'fox', challenged: 'ham', challenger: 'eggs')
      game.make_move(5, 'ham')
      game.make_move(2, 'eggs')
      game.make_move(1, 'ham')
      game.make_move(8, 'eggs')
      post :move, { channel_id: 'fox', user_name: 'ham', text: '9', token: '2g4fusktmXo8GikeHiAduMsK' }
      expect(get_text(response)).to eq "ham has triumphed on the field of battle!\n"\
                                  ":heart_eyes:|:skull:|-\n"\
                                  "-|:heart_eyes:|-\n"\
                                  "-|:skull:|:heart_eyes:"
      expect(GameManager.fetch('fox')).to eq nil
    end
  end
end
