require 'game/game_manager'

class GamesController < ApplicationController
  before_action :set_game

  def display
    render json: {
      response_type: 'in_channel',
      text:  GameManager.print_game(params[:channel_id])
    }
  end

  def challenge
    text = ''
    if @game.nil? && params[:user_name] != params[:text]
      GameManager.start_new_game(channel_id: params[:channel_id], challenged: params[:text], challenger: params[:user_name])
        text = "#{params[:user_name]} has challenged #{params[:text]} to a game of tic tac toe!"
    elsif params[:user_name] == params[:text]
        text = "You may not challenge yourself."
    else
      text = "A game between #{@game.player1} and #{@game.player2} is already ongoing!"
    end
    render json: {
      response_type: 'in_channel',
      text: text
    }
  end

  def help
    render plain: "This is some helpful help tic tac toe text!\n"\
                  "/challenge <USERNAME> will cause you to start a new game with <USERNAME> if there is no preexisting game.\n"\
                  "/move <i> will put your mark into the ith position on the board. The top left corner is 1, the bottom right one is 9.\n"\
                  "/display will print the current game out, if there is a game\n"
  end

  def move
    if @game.nil?
      render plain: "No game is currently ongoing. You should challenge someone!"
    else
      render_string = ''
      begin
        result = @game.make_move(params[:text].to_i, params[:user_name])
        if result
          # Save the final result of the game so we can display it in the channel.
          victory_board = @game.print_victory_board
          # Clear the channel of games so a new one can later start.
          GameManager.delete(params[:channel_id])
          render_string = "#{params[:user_name]} has triumphed on the field of battle!\n"\
                        "#{victory_board}"
        else
          render_string = "#{params[:user_name]} has made a move.\n#{@game.print_board}"
        end
      rescue GameException => e
        render_string = e.message
      end
      render json: {
        response_type: 'in_channel',
        text: render_string
      }
    end
  end

  def cheat
  end

  private

  def set_game
    @game = GameManager.fetch(params[:channel_id])
  end
end
