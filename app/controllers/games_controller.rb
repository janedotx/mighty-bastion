require 'game/game_manager'

class GamesController < ApplicationController
  before_action :set_game
  before_action :set_current_user

  before_action :game_nil_check, only: [:display, :move]

  # Display the current state of the game.
  def display
      render json: {
        response_type: 'in_channel',
        text:  "It is #{@game.next_player}'s turn.\n#{GameManager.print_game(params[:channel_id])}"
      }
  end

  # Challenge a player and start a new game.
  def challenge
    text = ''
    if @game.nil? && @current_user != params[:text]
      GameManager.start_new_game(channel_id: params[:channel_id], challenged: params[:text], challenger: @current_user)
        text = "#{@current_user} has challenged #{params[:text]} to a game of tic tac toe!"
    elsif @current_user == params[:text]
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
    render_string = ''
    begin
      result = @game.make_move(params[:text].to_i, @current_user)
      render_string = case result
      when :winner
        # Save the final result of the game so we can display it in the channel.
        victory_board = @game.print_victory_board
        # Clear the channel of games so a new one can later start.
        GameManager.delete(params[:channel_id])
        "#{@current_user} has triumphed on the field of battle!\n"\
                      "#{victory_board}"
      when :continue
        render_string = "#{@current_user} has made a move.\n#{@game.print_board}"
      when :tie
        board = @game.print_board
        GameManager.delete(params[:channel_id])
        "It ended in a tie.\n"\
                        "#{board}"
      end
    rescue GameException => e
      render_string = e.message
    end
    render json: {
      response_type: 'in_channel',
      text: render_string
    }
  end

  def cheat
    if @game.nil?
      render plain: "Shh, your attempt to cheat won't work right now. There's no game right now."
    else
      board = @game.print_cheating_board
      GameManager.delete(params[:channel_id])
      render json: {
        response_type: 'in_channel',
        text: "Oh wow! #{@current_user} has mysteriously won by dint of superior merit.\n"\
              "#{board}"
      }
    end
  end

  private

  def set_game
    @game = GameManager.fetch(params[:channel_id])
  end

  def set_current_user
    @current_user = params[:user_name]
  end

  def game_nil_check
    render plain: "No game ongoing. You should challenge someone!" if @game.nil?
  end
end
