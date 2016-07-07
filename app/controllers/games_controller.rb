require 'game/game_manager'

class GamesController < ApplicationController
  def display
    render plain: GameManager.print_game(params[:channel_id])
  end

  def challenge
    game = GameManager.games[params[:channel_id]]
    if game.nil?
      GameManager.start_new_game(channel_id: params[:channel_id], challenged: params[:text], challenger: params[:user_name])
      render plain: "#{params[:user_name]} has challenged #{params[:text]} to a game of tic tac toe!"
    else
      render plain: "A game between #{game.player1} and #{game.player2} is already ongoing!"
    end
  end

  def help
    render plain: "This is some helpful help tic tac toe text!\n"\
                  "/challenge <USERNAME> will cause you to start a new game with <USERNAME> if there is no preexisting game.\n"\
                  "/display will print the current game out, if there is a game\n"
                  "/help displays this help text"
  end

  def move
    game = GameManager.games[params[:channel_id]]
    if game.nil?
      render plain: "No game is currently ongoing. You should challenge someone!"
    else
      if params[:user_name] != game.current_player
        render plain: "It isn't your turn!"
      else
        result = game.make_move(params[:x], params[:y], params[:user_name])
        board = game.print_board
        if result
          # save the final result of the game so we can display it in the channel
          # clear the channel of games so a new one can later start
          GameManager.games.delete(params[:channel_id])
          render plain: "#{params[:user_name]} has triumphed on the field of battle! :joy:\n"\
                        "#{board}\n"\
                        ":joy: :joy:"
        else
          render plain: "#{params[:user_name]} has made a move.\n"\
                        "#{board}"
        end
      end
    end
  end
end
